{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
        ignore_empty_password = true;
        disable_loading_bar = true;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
        vignette = true;
      }];

      input-field = [{
        size = "300, 60";
        position = "0, -120";
        halign = "center";
        valign = "center";
        outline_thickness = 3;
        dots_size = 0.3;
        dots_spacing = 0.3;
        outer_color = "rgb(89b4fa)";
        inner_color = "rgba(0, 0, 0, 0)";
        font_color = "rgb(cdd6f4)";
        check_color = "rgb(89dceb)";
        fail_color = "rgb(f38ba8)";
        capslock_color = "rgb(fab387)";
        fade_on_empty = false;
        placeholder_text = "";
        font_family = "JetBrainsMono Nerd Font";
      }];

      label = [
        {
          text = "$TIME";
          color = "rgb(cdd6f4)";
          font_size = 90;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:60000] date +\"%A, %d %B\"";
          color = "rgb(cdd6f4)";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
