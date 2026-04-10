{ pkgs, ... }:
let
  mkScript = name: src: vars: pkgs.runCommand name { } ''
    install -Dm755 ${pkgs.replaceVars src vars} $out
  '';

  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  makoctl = "${pkgs.mako}/bin/makoctl";
  python = "${pkgs.python3}";

  notificationScript = mkScript "waybar-notification" ./scripts/notification.sh {
    inherit jq makoctl;
  };
  mprisPlayScript = mkScript "waybar-mpris-play" ./scripts/mpris-play.py {
    inherit python playerctl;
  };
  mprisProgressScript = mkScript "waybar-mpris-progress" ./scripts/mpris-progress.py {
    inherit python playerctl;
  };
  mprisTitleScript = mkScript "waybar-mpris-title" ./scripts/mpris-title.py {
    inherit python playerctl;
  };
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 48;
        spacing = 0;
        modules-left = [ "custom/nixos" "bluetooth" "niri/language" "network#speed" "custom/notification" "custom/mpris-play" "custom/mpris-progress" "custom/mpris-title" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "wireplumber" "disk" "cpu" "memory" "temperature" "network" "custom/power" ];

        "custom/nixos" = {
          format = "<span font='Symbols Nerd Font Mono'>󱄅</span>";
          tooltip = false;
        };

        bluetooth = {
          format = "<span font='Symbols Nerd Font Mono'>󰂯</span>";
          format-connected = "<span font='Symbols Nerd Font Mono'>󰂯</span> {device_alias}";
          format-disabled = "<span font='Symbols Nerd Font Mono'>󰂲</span>";
          tooltip-format = "{controller_alias}\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          on-click = "bluetoothctl power toggle";
        };

        "niri/language" = {
          format = "{}";
        };

        "network#speed" = {
          format = "<span font='Symbols Nerd Font Mono'>󰇚</span> {bandwidthDownBits}  <span font='Symbols Nerd Font Mono'>󰕒</span> {bandwidthUpBits}";
          interval = 2;
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "custom/notification" = {
          exec = "${notificationScript}";
          return-type = "json";
          interval = 2;
          escape = false;
          tooltip = false;
          on-click = "makoctl dismiss";
          on-click-right = "makoctl dismiss --all";
        };

        "custom/mpris-play" = {
          exec = "${mprisPlayScript}";
          return-type = "json";
          interval = 1;
          escape = false;
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl previous";
        };

        "custom/mpris-progress" = {
          exec = "${mprisProgressScript}";
          return-type = "json";
          interval = 1;
          escape = false;
        };

        "custom/mpris-title" = {
          exec = "${mprisTitleScript}";
          return-type = "json";
          interval = 1;
          escape = false;
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        clock = {
          format = "{:%H:%M  ·  %a %d}";
          format-alt = "{:%A, %d de %B de %Y  ·  %H:%M:%S}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        wireplumber = {
          format = "<span font='Symbols Nerd Font Mono'>{icon}</span> {volume}%";
          format-muted = "<span font='Symbols Nerd Font Mono'>󰝟</span>";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          max-volume = 150;
          scroll-step = 5;
          tooltip-format = "{node_name}: {volume}%";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        cpu = {
          format = "<span font='Symbols Nerd Font Mono'></span> {usage}%";
          tooltip = true;
        };

        memory = {
          format = "<span font='Symbols Nerd Font Mono'>󰍛</span> {}%";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 75;
          "format" = "{temperatureC}°C {icon}";
          "format-critical" = "{temperatureC}°C {icon}";
          "format-icons" = ["" "" ""];
        };

        disk = {
          format = "<span font='Symbols Nerd Font Mono'>󰋊</span> {percentage_used}%";
          path = "/";
          interval = 30;
          tooltip-format = "{path}: {used} / {total} ({percentage_used}%)";
        };

        network = {
          format-wifi = "<span font='Symbols Nerd Font Mono'>󰖩</span> {signalStrength}%";
          format-ethernet = "<span font='Symbols Nerd Font Mono'>󰈀</span>";
          format-disconnected = "<span font='Symbols Nerd Font Mono'>󰖪</span>";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}";
          tooltip-format-ethernet = "{ifname}: {ipaddr}";
          on-click = "ghostty --title=nmtui -e nmtui";
        };

        "custom/power" = {
          format = "<span font='Symbols Nerd Font Mono'>󰐥</span>";
          tooltip = false;
          on-click = "niri msg action quit";
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
