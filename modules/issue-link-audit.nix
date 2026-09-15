# Exposes `nix run .#check-stale-issue-links`: scans source comments for
# issue-tracker links and, when a referenced issue has been closed,
# opens/updates a single tracking issue so stale workarounds/TODOs get
# noticed. GitHub only for now — see issue_state below to add a provider.
#
# Local usage needs `gh` authenticated (`gh auth login`, or set `GH_TOKEN`).
{
  perSystem =
    { pkgs, ... }:
    {
      packages.check-stale-issue-links = pkgs.writeShellApplication {
        name = "check-stale-issue-links";
        runtimeInputs = [
          pkgs.gh
          pkgs.ripgrep
          pkgs.coreutils
        ];
        text = ''
          TRACKING_LABEL="stale-issue-links"
          TRACKING_TITLE="Stale issue-link audit"
          GITHUB_PATTERN='https://github\.com/[^/[:space:]]+/[^/[:space:]]+/issues/[0-9]+'

          # To add another provider's URL pattern here, e.g.
          #   GITLAB_PATTERN='https://gitlab\.com/[^/[:space:]]+(/[^/[:space:]]+)*/-/issues/[0-9]+'
          #   patterns+=(-e "$GITLAB_PATTERN")
          patterns=(-e "$GITHUB_PATTERN")

          url_host() {
            local url="$1" rest
            rest="''${url#*://}"
            printf '%s' "''${rest%%/*}"
          }

          github_issue_state() {
            local url="$1"
            gh issue view "$url" --json state --jq '.state' 2>/dev/null
          }

          # "https://github.com/OWNER/REPO/issues/N" -> "OWNER/REPO#N"
          github_issue_ref() {
            local url="$1" path owner rest repo number
            path="''${url#*://}"
            path="''${path#*/}"
            owner="''${path%%/*}"
            rest="''${path#*/}"
            repo="''${rest%%/*}"
            number="''${rest##*/}"
            printf '%s/%s#%s' "$owner" "$repo" "$number"
          }

          issue_state() {
            local url="$1"
            case "$(url_host "$url")" in
              github.com)
                github_issue_state "$url"
                ;;
              *)
                echo "unsupported issue-tracker host: $(url_host "$url")" >&2
                return 1
                ;;
            esac
          }

          issue_ref() {
            local url="$1"
            case "$(url_host "$url")" in
              github.com)
                github_issue_ref "$url"
                ;;
              *)
                printf '%s' "$url"
                ;;
            esac
          }

          echo "Scanning repository for issue-tracker links..." >&2

          stale_rows=()
          while IFS= read -r match; do
            [ -z "$match" ] && continue
            [[ "$match" =~ ^([^:]+):([0-9]+):(.*)$ ]] || continue
            file="''${BASH_REMATCH[1]#./}"
            lineno="''${BASH_REMATCH[2]}"
            url="''${BASH_REMATCH[3]}"

            if ! state="$(issue_state "$url")"; then
              echo "warning: could not look up $url (referenced at $file:$lineno)" >&2
              continue
            fi

            if [ "$state" = "CLOSED" ]; then
              stale_rows+=("- \`$file:$lineno\` — $(issue_ref "$url")")
            fi
          done < <(rg -n -o --no-messages "''${patterns[@]}" .)

          existing_issue="$(
            gh issue list --state open --label "$TRACKING_LABEL" --limit 50 \
              --json number,title \
              --jq "[.[] | select(.title == \"$TRACKING_TITLE\")][0].number // empty"
          )"

          if [ "''${#stale_rows[@]}" -eq 0 ]; then
            echo "No stale issue links found."
            if [ -n "$existing_issue" ]; then
              gh issue close "$existing_issue" \
                --comment "All previously flagged issue links have been resolved or removed. Closing this tracking issue."
              echo "Closed tracking issue #$existing_issue."
            fi
            exit 0
          fi

          body_file="$(mktemp)"
          trap 'rm -f "$body_file"' EXIT

          {
            echo "Found reference(s) to issues that have since been closed — the linked workaround(s) might not be needed anymore."
            echo
            printf '%s\n' "''${stale_rows[@]}"
            echo
            echo "_Last checked: $(date -u +%Y-%m-%dT%H:%M:%SZ) by the \`check-stale-issue-links\` scheduled workflow._"
          } > "$body_file"

          gh label create "$TRACKING_LABEL" \
            --color FBCA04 \
            --description "Automatically tracked by check-stale-issue-links" \
            --force >/dev/null 2>&1 || true

          if [ -n "$existing_issue" ]; then
            gh issue edit "$existing_issue" --body-file "$body_file"
            echo "Updated tracking issue #$existing_issue."
          else
            gh issue create \
              --title "$TRACKING_TITLE" \
              --label "$TRACKING_LABEL" \
              --body-file "$body_file"
            echo "Opened new tracking issue."
          fi
        '';
      };
    };
}
