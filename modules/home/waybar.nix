{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 48;
        spacing = 0;
        modules-left = [ "custom/nixos" "bluetooth" "niri/language" "network#speed" "custom/notification" ];
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
          format = "<span font='Symbols Nerd Font Mono'>󰂚</span>";
          tooltip = false;
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
          format = "<span font='Symbols Nerd Font Mono'></span> {usage}%";
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
          "format-icons" = ["" "" ""];
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

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "JetBrainsMono NF", "Symbols Nerd Font Mono", monospace;
        font-size: 17px;
        min-height: 0;
      }

      window#waybar {
        background-color: transparent;
        color: #cdd6f4;
        border: none;
      }

      /* Todos os módulos - sem background individual */
      #custom-nixos,
      #bluetooth,
      #language,
      #network.speed,
      #custom-notification,
      #clock,
      #tray,
      #wireplumber,
      #disk,
      #cpu,
      #memory,
      #temperature,
      #network,
      #custom-power {
        padding: 0 8px;
        color: #cdd6f4;
      }

      /* Grupo esquerda - pill única */
      .modules-left {
        background-color: rgba(17, 17, 27, 0.90);
        border-radius: 14px;
        margin: 5px 0 5px 6px;
        padding: 0 4px;
      }

      /* Grupo centro - pill única */
      .modules-center {
        background-color: rgba(17, 17, 27, 0.90);
        border-radius: 14px;
        margin: 5px 0;
        padding: 0 4px;
      }

      /* Grupo direita - sem background, só container */
      .modules-right {
        background-color: transparent;
        margin: 5px 6px 5px 0;
        padding: 0;
      }

      /* Tray - pill separada */
      #tray {
        background-color: rgba(17, 17, 27, 0.90);
        border-radius: 14px;
        padding: 0 10px;
        margin-right: 6px;
      }

      /* Demais módulos do right - pill única */
      #wireplumber,
      #disk,
      #cpu,
      #memory,
      #temperature,
      #network,
      #custom-power {
        background-color: rgba(17, 17, 27, 0.90);
        padding: 0 12px;
      }

      #wireplumber {
        border-radius: 14px 0 0 14px;
        padding-left: 14px;
      }

      #custom-power {
        border-radius: 0 14px 14px 0;
        padding-right: 14px;
      }

      #clock {
        font-weight: bold;
        padding: 0 10px;
      }

      #tray {
        color: #9399b2;
      }

      #wireplumber { color: #f5c2e7; }
      #wireplumber.muted { color: #6c7086; }
      #cpu { color: #a6e3a1; }
      #memory { color: #89b4fa; }
      #temperature { color: #fab387; }
      #temperature.critical { color: #f38ba8; }
      #disk { color: #cba6f7; }
      #network { color: #89dceb; }
      #custom-power { color: #f38ba8; }
      #custom-nixos { color: #89b4fa; }

      tooltip {
        background-color: #1e1e2e;
        border: 1px solid rgba(17, 17, 27, 0.85);
        border-radius: 8px;
        color: #cdd6f4;
      }
    '';
  };
}
