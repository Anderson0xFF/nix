{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        modules-left = [ "bluetooth" "niri/language" "network#speed" "custom/notification" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "wireplumber" "cpu" "memory" "temperature" "network" "custom/power" ];

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
          format = "<span font='Symbols Nerd Font Mono'>󰔄</span> {temperatureC}°";
          critical-threshold = 80;
          format-critical = "<span font='Symbols Nerd Font Mono'>󰔄</span> {temperatureC}°";
        };

        network = {
          format-wifi = "<span font='Symbols Nerd Font Mono'>󰖩</span> {signalStrength}%";
          format-ethernet = "<span font='Symbols Nerd Font Mono'>󰈀</span>";
          format-disconnected = "<span font='Symbols Nerd Font Mono'>󰖪</span>";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}";
          tooltip-format-ethernet = "{ifname}: {ipaddr}";
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
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(17, 17, 27, 0.85);
        color: #cdd6f4;
        border: none;
      }

      /* Pills da esquerda */
      #bluetooth,
      #language,
      #network.speed,
      #custom-notification {
        background-color: rgba(17, 17, 27, 0.85);
        border-radius: 8px;
        padding: 0 10px;
        margin: 4px 3px;
        color: #cdd6f4;
      }

      /* Centro - relógio em pill */
      #clock {
        background-color: rgba(17, 17, 27, 0.85);
        border-radius: 8px;
        padding: 0 14px;
        margin: 4px 3px;
        font-weight: bold;
        color: #cdd6f4;
      }

      /* Direita - pills arredondadas com cor de acento */
      #wireplumber,
      #cpu,
      #memory,
      #temperature,
      #network,
      #custom-power {
        background-color: rgba(17, 17, 27, 0.85);
        border-radius: 8px;
        padding: 0 10px;
        margin: 4px 3px;
      }

      #tray {
        padding: 0 6px;
        margin: 2px 2px;
        color: #9399b2;
      }

      #wireplumber { color: #f5c2e7; }
      #wireplumber.muted { color: #6c7086; }
      #cpu { color: #a6e3a1; }
      #memory { color: #89b4fa; }
      #temperature { color: #fab387; }
      #temperature.critical { color: #f38ba8; }
      #network { color: #89dceb; }
      #custom-power { color: #f38ba8; }

      #bluetooth {
        margin-left: 6px;
      }

      #custom-power {
        margin-right: 6px;
      }

      tooltip {
        background-color: #1e1e2e;
        border: 1px solid rgba(17, 17, 27, 0.85);
        border-radius: 8px;
        color: #cdd6f4;
      }
    '';
  };
}
