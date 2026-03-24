{ pkgs, ... }:  # <-- faltava o pkgs aqui
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "window.titleBarStyle" = "custom";
      "window.customTitleBarVisibility" = "never";
      "window.menuBarVisibility" = "hidden";
    };
  };

  home.file.".config/code-flags.conf".text = ''
    --enable-features=UseOzonePlatform,WaylandWindowDecorations
    --ozone-platform=wayland
  '';
}