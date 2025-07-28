{
  config,
  lib,
  pkgs,
  dotemacs,
  ...
}:

let
  fm-tools = with pkgs; [
    # cool languages
    fstar
    eff
    ocamlPackages.elpi

    # provers
    ## agda
    (agda.withPackages (
      with agdaPackages;
      [
        standard-library
        cubical
        agda-categories
        _1lab
      ]
    ))

    ## lean4
    elan

    ## idris2
    idris2
    idris2Packages.pack

    ## abella
    abella
  ];
in

{
  home.username = lib.mkDefault "godalin";
  home.packages =
    with pkgs;
    [
      # utils
      gawk
      jq
      pandoc
      unar
      rlwrap
      nmap

      # languages
      rustup
      sbcl
      typst
    ]
    ++ fm-tools;

  home.file.".config/agda/defaults".source = ./agda-defaults;

  # emacs configuration
  home.file.".config/emacs/lisp".source = "${dotemacs}/lisp";
  home.file.".config/emacs/init.el".source = "${dotemacs}/init.el";
  home.file.".config/emacs/early-init.el".source = "${dotemacs}/early-init.el";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    envExtra = ''
      export PATH=$PATH:"$HOME/.ghcup/bin"

      # brew specific configurations, on MacOS
      if [[ -d /opt/homebrew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export HOMEBREW_AUTO_UPDATE_SECS=3600
        export HOMEBREW_NO_ENV_HINTS=1
      fi
    '';
    shellAliases = {
      cat = "bat -pP";
      em = "emacs -nw";
      sbcl = "rlwrap sbcl";
    };
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "brackets"
      ];
      patterns = {
        comment = "fg=black,bold";
      };
    };
    oh-my-zsh = {
      enable = true;
      theme = "half-life";
      plugins = [
        "sudo"
        "git"
        "docker"
        "cabal"
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    tmuxinator.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Linyu Yang";
    userEmail = "yly1228@foxmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      color.ui = true;
      pull.rebase = false;
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ranger = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.bottom = {
    enable = true;
  };

  # editors

  programs.vim = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    client.enable = true;
  };

  programs.opam = {
    enable = true;
    enableZshIntegration = true;
  };

  home.stateVersion = "25.05";
}
