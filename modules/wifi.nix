{
  # TP-Link 2357:0138 USB dongle (rtw88_8822bu). Deep LPS wedges the firmware:
  # CTRL-EVENT-BEACON-LOSS + "failed to get tx report from firmware", link stays
  # associated so NetworkManager never reconnects. Only a driver reload recovers.
  den.aspects.wifi.nixos = {
    boot.extraModprobeConfig = "options rtw88_core disable_lps_deep=1";
    networking.networkmanager.wifi.powersave = false;
  };
}
