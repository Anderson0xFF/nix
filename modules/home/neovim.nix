{ pkgs, nix4nvchad, ... }:
{
  imports = [
    nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    hm-activation = true;
    backup = true;

    extraPackages = with pkgs; [
      # Dependências
      gcc
      gnumake
      unzip
      wget
      curl
      tree-sitter
      ripgrep
      fd

      # LSPs
      lua-language-server
      nil
      nodePackages.typescript-language-server
    ];

    extraPlugins = ''
      return {
        {
          "nvim-tree/nvim-tree.lua",
          opts = {
            view = {
              adaptive_size = true,
            },
          },
        },
      }
    '';

    chadrcConfig = ''
---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "rxyhn",
}

return M
    '';

    extraConfig = ''
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "rust_analyzer", "nil_ls", "ts_ls" }
vim.lsp.enable(servers)

-- Reabilitar navegação com setas (NvChad desabilita por padrão)
local nomap = vim.keymap.del

pcall(function()
  for _, mode in ipairs({ "n", "i", "v" }) do
    nomap(mode, "<Up>")
    nomap(mode, "<Down>")
    nomap(mode, "<Left>")
    nomap(mode, "<Right>")
  end
end)

-- Navegar entre janelas/splits com Ctrl+Setas
local map = vim.keymap.set
map("n", "<C-Left>", "<C-w>h", { desc = "Window left" })
map("n", "<C-Down>", "<C-w>j", { desc = "Window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "Window up" })
map("n", "<C-Right>", "<C-w>l", { desc = "Window right" })
    '';
  };
}
