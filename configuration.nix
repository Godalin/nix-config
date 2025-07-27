# This file is the Nix-Darwin configuration for my macOS system.

{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nil
    vim
    neovim
    git
    neofetch

    # shells
    scsh
    elvish
    nushell
    tmux

    # some utils
    patch

    # texlive
    texliveFull
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  users.knownUsers = [ "godalin" ];
  users.users.godalin = {
    name = "godalin";
    uid = 501;
    home = "/Users/godalin";
  };

  # launchd.user.envVariables.PATH = config.environment.systemPath;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/services"
    ];
    brews = [
      "coreutils"
      "mihomo"
      "imagemagick"
      "pkgconfig"

      "golang"
      "ghcup"
      # "opam"

      "zlib"
      "graphviz"
      "wget"
      "hugo"

      "librime"
      "ispell"
      "nethack"
      "ollama"
      # "anythingllm"
    ];
    casks = [
      "squirrel-app"
      "alacritty"
      "zotero"
      "obsidian"
      "firefox"
      "drawio"
      # "inkscape"

      # languages
      # "racket"
      "miniconda"

      # editors
      "visual-studio-code"
      "typora"
      # "emacs-app"
      # "texmacs"
      # "cursor"

      # MacOS utilities
      "jordanbaird-ice"
      "karabiner-elements"
      "flameshot"
      "syncthing-app"
      "whisky"
      # "calibre"

      # "orbstack"
    ];
  };

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    lxgw-wenkai
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.dejavu-sans-mono
  ];

  system.primaryUser = "godalin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = config.rev or config.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  # programs.darwin.enable = true;
  # services.nix-daemon.enable = true;
  # services.nix-daemon.enable = true;
}
