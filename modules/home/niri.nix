{ config, ... }:
let
  a = config.lib.niri.actions;
in
{
  programs.niri.settings = {
    input.keyboard.xkb = {
      layout = "us,br";
      options = "grp:alt_shift_toggle";
    };

    prefer-no-csd = true;
    spawn-at-startup = [
      { command = [ "waybar" ]; }
      # { command = [ "xwayland-satellite" ]; }  # Desabilitado: causa crash de apps X11 ao desligar monitor
      { command = [ "awww-daemon" ]; }
      { command = [ "swayosd-server" ]; }
    ];

    layout = {
      gaps = 8;
      struts = {
        left = 12;
        right = 12;
        bottom = 8;
      };

      # Configuração recomendada para workflow de código
      always-center-single-column = false;
      center-focused-column = "never";  # Não centralizar automaticamente
      preset-column-widths = [
        { proportion = 0.33333; }  # Terminal lateral
        { proportion = 0.5; }      # Editor balanceado
        { proportion = 0.66667; }  # Browser principal
      ];
      default-column-width = { proportion = 0.5; };

      border = {
        enable = true;
        width = 2;
        active.gradient = {
          from = "red";
          to = "orange";
          angle = 45;
          in' = "oklch longer hue";
          relative-to = "workspace-view";
        };
        inactive.color = "#333333";
      };

      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#00000077";
      };

      focus-ring.enable = false;
    };

    window-rules = [
      # Regra global: cantos arredondados em todas as janelas
      {
        matches = [{}];
        geometry-corner-radius = {
          top-left = 4.0;
          top-right = 4.0;
          bottom-left = 4.0;
          bottom-right = 4.0;
        };
        clip-to-geometry = true;
      }

      # xdg-desktop-portal: file pickers de qualquer app
      {
        matches = [{ app-id = "^xdg-desktop-portal"; }];
        open-floating = true;
        max-width = 1200;
        max-height = 800;
      }

      # Thunar: diálogos específicos
      {
        matches = [
          { app-id = "^thunar$"; title = "Open With"; }
          { app-id = "^thunar$"; title = "Properties"; }
          { app-id = "^thunar$"; title = "Rename"; }
          { app-id = "^thunar$"; title = "Create"; }
          { app-id = "^thunar$"; title = "Confirm"; }
          { app-id = "^thunar$"; title = "Delete"; }
          { app-id = "^thunar$"; title = "Execute"; }
        ];
        open-floating = true;
        max-width = 800;
        max-height = 600;
      }

      # Firefox: Picture-in-Picture
      {
        matches = [
          { app-id = "^firefox$"; title = "^Picture-in-Picture$"; }
        ];
        open-floating = true;
        max-width = 640;
        max-height = 360;
      }

      # Firefox: diálogos de salvar, upload e autenticação
      # Títulos ancorados para não casar páginas web que comecem com "Open"/"Sign in"/etc.
      {
        matches = [
          { app-id = "^firefox$"; title = "^Enter name of file to save to"; }
          { app-id = "^firefox$"; title = "^Salvar como$"; }
          { app-id = "^firefox$"; title = "^File Upload$"; }
          { app-id = "^firefox$"; title = "^Enviar arquivo$"; }
          { app-id = "^firefox$"; title = "^Authentication Required$"; }
          { app-id = "^firefox$"; title = "^Autenticação necessária$"; }
        ];
        open-floating = true;
        max-width = 960;
        max-height = 720;
      }

      # Polkit: janelas de autenticação do sistema
      {
        matches = [
          { app-id = "^polkit-gnome-authentication-agent-1$"; }
          { app-id = "polkit"; }
        ];
        open-floating = true;
        max-width = 600;
        max-height = 400;
      }

      # nmtui: gerenciador de rede floating
      {
        matches = [
          { app-id = "^com\\.mitchellh\\.ghostty$"; title = "^nmtui$"; }
        ];
        open-floating = true;
        default-column-width = {};
        default-window-height = {};
        max-width = 800;
        max-height = 600;
      }

      # wiremix: gerenciador de audio floating
      {
        matches = [
          { app-id = "^com\\.mitchellh\\.ghostty$"; title = "^wiremix$"; }
        ];
        open-floating = true;
        default-column-width = {};
        default-window-height = {};
        max-width = 800;
        max-height = 600;
      }

      # Waypaper: seletor de wallpaper floating
      {
        matches = [{ app-id = "^waypaper$"; }];
        open-floating = true;
        max-width = 900;
        max-height = 600;
      }

      # Ghostty: blur no background
      {
        matches = [{ app-id = "^com\\.mitchellh\\.ghostty$"; }];
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-left = 8.0;
          bottom-right = 8.0;
        };
        clip-to-geometry = true;
        background-effect.blur.enable = true;
      }

    ];

    layer-rules = [
      # Waybar: blur atrás da barra
      {
        matches = [{ namespace = "^waybar$"; }];
        background-effect.blur.enable = true;
      }
    ];

    binds = {
      # Terminal e launcher
      "Mod+Return".action = a.spawn "ghostty";
      "Mod+D".action = a.spawn "walker";

      # Niri
      "Mod+Shift+Slash".action = a.show-hotkey-overlay;
      "Mod+Shift+E".action = a.quit;
      "Mod+Shift+P".action = a.power-off-monitors;

      # Janelas
      "Mod+Q".action = a.close-window;
      "Mod+F".action = a.maximize-column;
      "Mod+Shift+F".action = a.fullscreen-window;

      # Foco
      "Mod+Left".action = a.focus-column-left;
      "Mod+Right".action = a.focus-column-right;
      "Mod+Up".action = a.focus-window-up;
      "Mod+Down".action = a.focus-window-down;
      # Lock screen
      "Mod+L".action = a.spawn "swaylock";

      # Mover janelas
      "Mod+Shift+Left".action = a.move-column-left;
      "Mod+Shift+Right".action = a.move-column-right;
      "Mod+Shift+Up".action = a.move-window-up;
      "Mod+Shift+Down".action = a.move-window-down;

      # Workspaces
      "Mod+Page_Down".action = a.focus-workspace-down;
      "Mod+Page_Up".action = a.focus-workspace-up;
      "Mod+U".action = a.focus-workspace-down;
      "Mod+I".action = a.focus-workspace-up;
      "Mod+Shift+Page_Down".action = a.move-column-to-workspace-down;
      "Mod+Shift+Page_Up".action = a.move-column-to-workspace-up;
      "Mod+Shift+U".action = a.move-column-to-workspace-down;
      "Mod+Shift+I".action = a.move-column-to-workspace-up;

      # Workspaces por número
      "Mod+1".action = a.focus-workspace 1;
      "Mod+2".action = a.focus-workspace 2;
      "Mod+3".action = a.focus-workspace 3;
      "Mod+4".action = a.focus-workspace 4;
      "Mod+5".action = a.focus-workspace 5;
      "Mod+6".action = a.focus-workspace 6;
      "Mod+7".action = a.focus-workspace 7;
      "Mod+8".action = a.focus-workspace 8;
      "Mod+9".action = a.focus-workspace 9;
      # Layout
      "Mod+R".action = a.switch-preset-column-width;
      "Mod+Shift+R".action = a.reset-window-height;
      "Mod+Minus".action = a.set-column-width "-10%";
      "Mod+Equal".action = a.set-column-width "+10%";
      "Mod+Shift+Minus".action = a.set-window-height "-10%";
      "Mod+Shift+Equal".action = a.set-window-height "+10%";

      # Consume/Expel
      "Mod+BracketLeft".action = a.consume-or-expel-window-left;
      "Mod+BracketRight".action = a.consume-or-expel-window-right;

      # Floating
      "Mod+V".action = a.toggle-window-floating;
      "Mod+Shift+V".action = a.switch-focus-between-floating-and-tiling;

      # Trocar layout do teclado
      "Mod+Shift+Space".action = a.switch-layout "next";

      # Screenshot (grim + slurp — sem borrão)
      # Print puro: área selecionada (padrão preferido). Shift+Print: tela inteira.
      "Print".action = a.spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy";
      "Shift+Print".action = a.spawn "sh" "-c" "grim - | wl-copy";
      "Mod+Print".action = a.spawn "sh" "-c" "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";
      "Mod+Shift+Print".action = a.spawn "sh" "-c" "grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

      # Overview
      "Mod+Tab".action = a.toggle-overview;

      # Teclas multimídia — mídia (playerctl) e volume (wpctl)
      "XF86AudioPlay" = {
        action = a.spawn "playerctl" "play-pause";
        allow-when-locked = true;
      };
      "XF86AudioPause" = {
        action = a.spawn "playerctl" "play-pause";
        allow-when-locked = true;
      };
      "XF86AudioStop" = {
        action = a.spawn "playerctl" "stop";
        allow-when-locked = true;
      };
      "XF86AudioNext" = {
        action = a.spawn "music-osd" "next";
        allow-when-locked = true;
      };
      "XF86AudioPrev" = {
        action = a.spawn "music-osd" "previous";
        allow-when-locked = true;
      };
      "XF86AudioRaiseVolume" = {
        action = a.spawn "swayosd-client" "--output-volume" "raise" "--max-volume" "150";
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        action = a.spawn "swayosd-client" "--output-volume" "lower";
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action = a.spawn "swayosd-client" "--output-volume" "mute-toggle";
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action = a.spawn "swayosd-client" "--input-volume" "mute-toggle";
        allow-when-locked = true;
      };
      "XF86MonBrightnessUp" = {
        action = a.spawn "brightness-osd" "up";
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action = a.spawn "brightness-osd" "down";
        allow-when-locked = true;
      };
      "Mod+F6".action = a.spawn "brightness-osd" "up";
      "Mod+F5".action = a.spawn "brightness-osd" "down";
    };

    gestures = {
      hot-corners = {
        enable = true;
      };
    };

    # Output do monitor — descomente e ajuste conforme a máquina
    outputs."DP-1" = {
      scale = 1.0;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 239.991;
      };
      # variable-refresh-rate = true;
    };
  };
}
