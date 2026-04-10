{ pkgs, ... }:
let
  notificationScript = pkgs.writeShellScript "waybar-mako-notification" ''
    count=$(${pkgs.mako}/bin/makoctl list -j | ${pkgs.jq}/bin/jq -r 'length')
    if [ "$count" -gt 0 ]; then
      icon='<span font="Symbols Nerd Font Mono">󱅫</span>'
      class="has-notifications"
    else
      icon='<span font="Symbols Nerd Font Mono">󰂚</span>'
      class="none"
    fi
    ${pkgs.jq}/bin/jq -nc --arg text "$icon" --arg class "$class" '{text: $text, class: $class, alt: $class}'
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
        modules-left = [ "custom/nixos" "bluetooth" "niri/language" "network#speed" "custom/notification" "mpris" ];
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

        mpris = {
          format = "<span font='Symbols Nerd Font Mono'>{player_icon}</span>  {dynamic}";
          format-paused = "<span font='Symbols Nerd Font Mono'>{status_icon}</span>  {dynamic}";
          format-stopped = "";
          player-icons = {
            default = "󰝚";
            spotify = "";
            firefox = "󰈹";
            chromium = "";
            mpv = "";
            vlc = "󰕼";
          };
          status-icons = {
            playing = "";
            paused = "";
          };
          dynamic-len = 40;
          dynamic-priority = [ "title" "artist" ];
          dynamic-separator = " · ";
          interval = 1;
          tooltip-format = "{player}: {status}\n{title}\n{artist}\n{album}";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
          on-click-middle = "playerctl previous";
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
      /* Cores principais - altere aqui para mudar o tema */
      @define-color bg-pill rgba(17, 17, 27, 0.90); /* fundo das pills */
      @define-color fg #cdd6f4;                     /* texto padrão */
      @define-color bg-tooltip #1e1e2e;             /* fundo dos tooltips */

      * {
        font-family: "JetBrainsMono Nerd Font", "JetBrainsMono NF", "Symbols Nerd Font Mono", monospace;
        font-size: 17px;
        min-height: 0;
      }

      window#waybar {
        background-color: transparent;
        color: @fg;
        border: none;
      }

      /* Todos os módulos - sem background individual */
      #custom-nixos,
      #bluetooth,
      #language,
      #network.speed,
      #custom-notification,
      #mpris,
      #clock,
      #tray,
      #wireplumber,
      #disk,
      #cpu,
      #memory,
      #temperature,
      #network,
      #custom-power {
        background-color: transparent;
        padding: 0 8px;
        color: @fg;
      }

      /* Grupo esquerda - transparente; cada subgrupo vira sua própria pill */
      .modules-left {
        background-color: transparent;
        margin: 5px 0 5px 6px;
        padding: 0;
      }

      /* Pill principal da esquerda - abraça do nixos até a notificação */
      #custom-nixos,
      #bluetooth,
      #language,
      #network.speed,
      #custom-notification {
        background-color: @bg-pill;
      }
      #custom-nixos {
        border-radius: 14px 0 0 14px;
        padding-left: 14px;
      }
      #custom-notification {
        border-radius: 0 14px 14px 0;
        padding-right: 14px;
      }

      /* MPRIS - pill separada ao lado da ilha principal */
      #mpris {
        background-color: @bg-pill;
        border-radius: 14px;
        padding: 0 14px;
        margin-left: 6px;
        color: #f5c2e7;
      }
      #mpris.paused {
        color: #9399b2;
      }

      /* Grupo centro - pill única */
      .modules-center {
        background-color: @bg-pill;
        border-radius: 14px;
        margin: 5px 0;
        padding: 0 4px;
      }

      /* Grupo direita - pill única com tray separado */
      .modules-right {
        background-color: transparent;
        margin: 5px 6px 5px 0;
        padding: 0;
      }

      /* Tray - pill separada */
      #tray {
        background-color: @bg-pill;
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
        background-color: @bg-pill;
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

      #tray { color: #9399b2; }
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
      #custom-notification.has-notifications { color: #f9e2af; }

      tooltip {
        background-color: @bg-tooltip;
        border: 1px solid @bg-pill;
        border-radius: 8px;
        color: @fg;
      }
    '';
  };
}
