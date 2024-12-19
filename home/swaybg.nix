{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.swaybg = {
    Unit = {
      After = ["niri.service"];
      Requires = ["niri.service"];
      PartOf = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} -m fill";
      Restart = "on-failure";
    };
  };
}
