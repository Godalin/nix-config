# Cross-Platform Nix Configuration

All these platforms can share the same `home.nix` for the `godalin` user.

## Nix-Darwin (macOS)

For MacOS with Nix-Darwin:

```sh
sudo darwin-rebuild switch --flake .#LinyudeMacBook-Air
```



## NixOS for WSL

For Windows Subsystem for Linux with NixOS-WSL:

```sh
sudo nixos-rebuild switch --flake .#gk-nixos-wsl
```



## NixOS

**TODO**



## Standalone Home Manager (Linux, e.g. Ubuntu)

For any x86_64 Linux machine with Home Manager:

### China

```sh
# Set Up Nix
sh <(curl -L https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install) --daemon

# Install Home Manager (if not already installed)
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Deploy from GitHub
home-manager switch --flake github:Godalin/nix-darwin#godalin@x86_64-linux
```

### Regular

```sh
# set up nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# Install Home Manager (if not already installed)
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Deploy from GitHub
home-manager switch --flake github:Godalin/nix-darwin#godalin@x86_64-linux
```
