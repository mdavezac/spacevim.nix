{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
      {
        timeout = 180;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 300;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  systemd.user.services.swayidle.Unit = {
    After = ["niri.service"];
    Requires = ["niri.service"];
  };
}
