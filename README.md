# NixOS Configuration

Configuração NixOS multi-host com Niri (Wayland), Home Manager e Ghostty.

## Estrutura

```
nixos/
├── flake.nix              # Hosts: vm, desktop
├── configuration.nix      # Módulos compartilhados entre hosts
├── home.nix               # Home Manager (compartilhado)
├── hosts/
│   ├── vm/                # Host da máquina virtual
│   │   ├── default.nix    # Entry point (imports)
│   │   └── boot.nix       # GRUB BIOS
│   └── desktop/           # Host do desktop principal
│       ├── default.nix    # Entry point (imports)
│       └── boot.nix       # UEFI systemd-boot
├── modules/
│   ├── system/            # Módulos do sistema (pacotes, rede, áudio, etc.)
│   └── home/              # Módulos do Home Manager (shell, niri, waybar, etc.)
└── assets/                # Wallpapers e outros recursos
```

> **Nota:** O arquivo `hardware-configuration.nix` de cada host **não é versionado**.
> Ele é gerado pela máquina durante a instalação e copiado manualmente para a pasta do host.

## Instalação em uma máquina nova

### 1. Instalar o NixOS normalmente

Use o instalador padrão do NixOS. Ele vai gerar o `/etc/nixos/hardware-configuration.nix` da sua máquina.

### 2. Clonar/copiar este repositório

```bash
# Coloque em /home/alynx/nixos
git clone <url-do-repo> /home/alynx/nixos
# ou copie manualmente
```

### 3. Copiar o hardware-configuration.nix gerado

Para a **VM**:
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos/hosts/vm/
```

Para o **Desktop**:
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos/hosts/desktop/
```

### 4. Aplicar a configuração

```bash
cd ~/nixos
git add .
git commit -m "add hardware-configuration"

# Para a VM:
sudo nixos-rebuild switch --flake .#vm

# Para o Desktop:
sudo nixos-rebuild switch --flake .#desktop
```

## Atualizando a configuração

Após modificar algum arquivo:

```bash
cd ~/nixos
git add .
git commit -m "descrição da mudança"

# Escolha o host da máquina atual:
sudo nixos-rebuild switch --flake .#vm
# ou
sudo nixos-rebuild switch --flake .#desktop
```

## Adicionando um novo host

1. Crie uma pasta em `hosts/<nome-do-host>/`
2. Crie um `default.nix` importando `../../configuration.nix`, `./hardware-configuration.nix` e `./boot.nix`
3. Crie um `boot.nix` com a configuração de boot da máquina (UEFI ou BIOS)
4. Adicione o host no `flake.nix`:
   ```nix
   nixosConfigurations.<nome-do-host> = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = commonModules ++ [ ./hosts/<nome-do-host> ];
   };
   ```
5. Na máquina, copie o `hardware-configuration.nix`:
   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/nixos/hosts/<nome-do-host>/
   ```
6. Aplique: `sudo nixos-rebuild switch --flake .#<nome-do-host>`
