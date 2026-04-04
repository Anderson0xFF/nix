{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Expõe o manifesto de layer Vulkan do RenderDoc via VK_ADD_LAYER_PATH
    # (evita a mensagem "layer not registered" e a tentativa de escrever em /etc).
    extraPackages = [ pkgs.renderdoc ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    renderdoc
  ];
}
