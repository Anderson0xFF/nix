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
      { command = [ "xwayland-satellite" ]; }
      { command = [ "swaybg" "-i" "/home/alynx/dotfiles/wallpapers/macOS Sonoma/Redwoods from Above.jpeg" "-m" "fill" ]; }
    ];

    layout = {
      gaps = 8;
      # struts = {
      #   left = 64;
      #   right = 64;
      # };

      # Configuração recomendada para workflow de código
      always-center-single-column = true;  # Editor centralizado quando sozinho
      center-focused-column = "always";
      # preset-column-widths = [
      #   { proportion = 0.33333; }  # Terminal lateral
      #   { proportion = 0.5; }      # Editor balanceado
      #   { proportion = 0.66667; }  # Browser principal
      # ];
      default-column-width = { proportion = 0.5; };  # Padrão 50%

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
      # Remove o bloco do code, não existe essa opção em window-rules
    ];

    binds = {
      # Terminal e launcher
      "Mod+Return".action = a.spawn "ghostty";
      "Mod+D".action = a.spawn "fuzzel";

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
      "Mod+H".action = a.focus-column-left;
      "Mod+L".action = a.focus-column-right;
      "Mod+K".action = a.focus-window-up;
      "Mod+J".action = a.focus-window-down;

      # Mover janelas
      "Mod+Shift+Left".action = a.move-column-left;
      "Mod+Shift+Right".action = a.move-column-right;
      "Mod+Shift+Up".action = a.move-window-up;
      "Mod+Shift+Down".action = a.move-window-down;
      "Mod+Shift+H".action = a.move-column-left;
      "Mod+Shift+L".action = a.move-column-right;
      "Mod+Shift+K".action = a.move-window-up;
      "Mod+Shift+J".action = a.move-window-down;

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
      "Mod+Space".action = a.switch-layout "next";

      # Screenshot via comando externo
      "Print".action = a.spawn "niri" "msg" "action" "screenshot";

      # Overview
      "Mod+Tab".action = a.toggle-overview;
    };

    gestures = {
      hot-corners = {
        enable = true;
      };
    };

    # Output do monitor — descomente e ajuste conforme a máquina
    outputs."HDMI-A-1" = {
      scale = 1.0;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 120.000;
      };
    };
};
}
