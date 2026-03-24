{ ... } :
{
    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                type = "kitty-direct";
                source = ../../assets/NixOS.png;
            };
            modules = [
                "title"
                "separator"
                "os"
                "host"
                "kernel"
                "uptime"
                "packages"
                "shell"
                "display"
                "de"
                "wm"
                "font"
                "cursor"
                "terminal"
                "cpu"
                "gpu"
                "memory"
                "swap"
                "disk"
                "locale"
            ];
        };
    };
}
