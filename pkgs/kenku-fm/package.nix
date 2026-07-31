{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libgbm,
  libglvnd,
  libpulseaudio,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd, # provides libudev
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libxfixes,
  libxrandr,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kenku-fm";
  version = "1.5.5";
  srcTag = "v1.5.5-2";
  src = fetchurl {
    url = "https://github.com/raidorev/kenku-fm/releases/download/${finalAttrs.srcTag}/kenku-fm_${finalAttrs.version}_amd64.deb";
    hash = "sha256-u0raYXKHOiXrg/jF04d8yiEGvZX/3PPQppMQedPtdtw=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  # DT_NEEDED of the Electron binary + bundled native .node modules.
  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    systemd
    libX11
    libXcomposite
    libXdamage
    libXext
    libxfixes
    libxrandr
    libxcb
  ];

  # dlopen'd at runtime by the bundled native modules — autoPatchelfHook puts these on
  # their RPATH. (GL/EGL libraries are handled via LD_LIBRARY_PATH in the wrapper below,
  # because Chromium's GPU process dlopens the system GL stack by soname.)
  runtimeDependencies = [
    libpulseaudio
  ];

  # `dpkg-deb -x` restores the setuid bit on chrome-sandbox, which the build sandbox
  # forbids; stream the data tarball through tar with --no-same-permissions instead
  # (the setuid helper is removed in installPhase regardless).
  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    runHook postUnpack
  '';

  # We call makeWrapper ourselves (below) to control Electron's flags; wrapGAppsHook3
  # still runs and exposes gappsWrapperArgs (GTK schemas, icons, etc.).
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share
    cp -a usr/lib/kenku-fm $out/opt/kenku-fm
    cp -a usr/share/applications $out/share/
    cp -a usr/share/pixmaps $out/share/

    # The setuid sandbox helper can't be setuid in the read-only nix store; drop it so
    # Electron falls back to the unprivileged user-namespace sandbox (allowed on NixOS).
    rm -f $out/opt/kenku-fm/chrome-sandbox

    # .desktop already uses Exec=kenku-fm / Icon=kenku-fm; the wrapper on PATH and the
    # pixmap satisfy both, so no rewrite is needed.

    makeWrapper $out/opt/kenku-fm/kenku-fm $out/bin/kenku-fm \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [ libglvnd ]
      }:${addDriverRunpath.driverLink}/lib" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = {
    description = "Online tabletop audio sharing for Discord";
    homepage = "https://www.kenku.fm/";
    downloadPage = "https://github.com/owlbear-rodeo/kenku-fm/releases";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kenku-fm";
  };
})
