{ pkgs, ... }:
let
  mkScript = name: src: vars: pkgs.runCommand name { } ''
    install -Dm755 ${pkgs.replaceVars src vars} $out
  '';

  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  makoctl = "${pkgs.mako}/bin/makoctl";
  python = "${pkgs.python3}";
  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  ddcui = "${pkgs.ddcui}/bin/ddcui";
  awk = "${pkgs.gawk}/bin/awk";

  notificationScript = mkScript "waybar-notification" ./scripts/notification.sh {
    inherit jq makoctl;
  };
  distroScript = mkScript "waybar-distro" ./scripts/distro.py {
    inherit python;
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
  brightnessScript = mkScript "waybar-brightness" ./scripts/brightness.sh {
    inherit ddcutil awk;
  };

  compiledStyle = pkgs.runCommand "waybar-style.css" { } ''
    ${pkgs.sassc}/bin/sassc -t expanded ${./style.scss} $out
  '';
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
        modules-left = [ "custom/nixos" "niri/language" "network#speed" "custom/mpris-play" "custom/mpris-progress" "custom/mpris-title" ];
        modules-center = [ "clock" "custom/notification" ];
        modules-right = [ "tray" "disk" "cpu" "memory" "custom/brightness" "wireplumber" "pulseaudio#microphone" "bluetooth" "network" "temperature" "custom/power" ];

        "custom/nixos" = {
          format = "{}";
          exec = "${distroScript}";
          return-type = "json";
          interval = 3600;
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
          on-click = "niri msg action switch-layout next";
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
          format = "<span font='Symbols Nerd Font Mono'>{icon}</span>";
          format-muted = "<span font='Symbols Nerd Font Mono'>󰝟</span>";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          max-volume = 150;
          scroll-step = 5;
          tooltip-format = "{node_name}: {volume}%";
        };

        "custom/brightness" = {
          exec = "${brightnessScript}";
          return-type = "json";
          interval = 5;
          signal = 8;
          on-scroll-up = "${ddcutil} setvcp 10 + 10 && pkill -RTMIN+8 waybar";
          on-scroll-down = "${ddcutil} setvcp 10 - 10 && pkill -RTMIN+8 waybar";
          on-click = "${ddcui}";
          tooltip = true;
        };

        "pulseaudio#microphone" = {
          format = "<span font='Symbols Nerd Font Mono'>{format_source}</span>";
          format-source = "󰍬";
          format-source-muted = "󰍭";
          tooltip-format = "Mic: {source_volume}% ({source_desc})";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          scroll-step = 5;
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };

        cpu = {
          format = "<span font='Symbols Nerd Font Mono'></span>";
          tooltip = true;
          tooltip-format = "CPU: {usage}%";
        };

        memory = {
          format = "<span font='Symbols Nerd Font Mono'>󰍛</span>";
          tooltip-format = "RAM: {used:0.1f} GiB / {total:0.1f} GiB ({percentage}%)";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 75;
          "format" = "<span font='Symbols Nerd Font Mono'>{icon}</span>";
          "format-critical" = "<span font='Symbols Nerd Font Mono'>{icon}</span>";
          "format-icons" = [ "" "" "" "" ];
          tooltip-format = "{temperatureC}°C";
        };

        disk = {
          format = "<span font='Symbols Nerd Font Mono'>󰋊</span>";
          path = "/";
          interval = 30;
          tooltip-format = "{path}: {used} / {total} ({percentage_used}%)";
        };

        network = {
          format-wifi = "<span font='Symbols Nerd Font Mono'>󰖩</span>";
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

    style = builtins.readFile compiledStyle;
  };
}
