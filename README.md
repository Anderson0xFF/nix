# NixOS Workstation

Configuração NixOS com Niri (Wayland), Home Manager e Ghostty.

## Instalação (máquina recém-formatada)

### 1. Copiar os arquivos para a máquina

Coloque esta pasta em `/home/alynx/nixos`.

### 2. Inicializar o repositório git

O Nix Flakes exige que o diretório seja um repositório git.

```bash
nix-shell -p git
cd /home/alynx/nixos
git init
git config user.email "andersonvsc1998@gmail.com"
git config user.name "Anderson Silva"
git add .
git commit -m "initial"
```

### 3. Aplicar a configuração

```bash
sudo nixos-rebuild switch --flake /home/alynx/nixos#nixos-workstation
```

## Atualizando (após modificar arquivos)

Sempre que modificar algum arquivo, faça commit e aplique:

```bash
nix-shell -p git
cd /home/alynx/nixos
git add .
git -c user.name='Anderson Silva' -c user.email='andersonvsc1998@gmail.com' commit -m "update"
sudo nixos-rebuild switch --flake /home/alynx/nixos#nixos-workstation
```
