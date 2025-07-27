# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  ...
}:

{
  wsl.enable = true;
  wsl.defaultUser = "godalin";

  nix.settings.experimental-features = "flakes nix-command";

  networking.hostName = "gk-nixos-wsl";

  users.users.godalin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # groups = [ "wheel" ];
  };

  users.groups.godalin = { };

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nil
    vim
    neovim
    emacs
    git
    wget
    gnumake
    gcc
    clang
  ];

  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
      echo loaded direnv!
    '';
    silent = true;
  };

  programs.nix-ld.enable = true;

  fonts.packages = with pkgs; [
    lxgw-wenkai
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.dejavu-sans-mono
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
