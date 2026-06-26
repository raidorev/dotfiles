{
  den.aspects.locale = { host, ... }: {
    nixos = {
      time.timeZone = "Europe/Moscow";
      i18n.defaultLocale = "en_US.UTF-8";
    };
  };
}
