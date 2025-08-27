{
  lib,
  ...
}@inputs:
let
  vscodeExtensions = [
    "redhat.vscode-yaml"
    "charliermarsh.ruff"
    "DavidAnson.vscode-markdownlint"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.mypy-type-checker"
    "mikestead.dotenv"
    "tamasfe.even-better-toml"
    "GitHub.vscode-pull-request-github"
    "eamodio.gitlens"
    "ms-vscode.makefile-tools"
    "vscodevim.vim"
    "dbaeumer.vscode-eslint"
    "YoavBls.pretty-ts-errors"
    "enkia.tokyo-night"
    "ryanluker.vscode-coverage-gutters"
    "ms-azuretools.vscode-docker"
  ];
  cursorExtensionCommand =
    "/opt/homebrew/bin/cursor "
    + builtins.concatStringsSep " " (builtins.map (ext: "--install-extension ${ext}") vscodeExtensions);
  secrets = import ../secrets.nix { };
in
{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
    home-manager.enable = true;
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent =
        let
          zshConfig = lib.mkOrder 1000 (builtins.readFile ./dotfiles/zsh/.zshrc);
          zshConfigLateInit = lib.mkOrder 1500 "[ -r \"$HOME/.config/private/zsh.secrets\" ] && source \"$HOME/.config/private/secrets.sh\"";
        in
        lib.mkMerge [
          zshConfig
          zshConfigLateInit
        ];

      shellAliases = {
        vim = "nvim";
        pr = "gh pr create --fill --web";
      };

      history = {
        size = 10000;
        expireDuplicatesFirst = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "tmux"
        ];
        theme = "robbyrussell";
      };
    };
    git = {
      enable = true;
      userName = "Clay McGinnis";
      userEmail = "github@clay.sh";

      ignores = [
        ".DS_Store"
        "*.sw?"
        ".attach_pid*"
      ];

      extraConfig = {
        core = {
          excludesfile = "~/.gitignore";
          autocrlf = "input";
          fsmonitor = true;
          untrackedCache = true;
        };

        column = {
          ui = "auto";
        };
        branch = {
          sort = "-committerdate";
        };
        tag = {
          sort = "version:refname";
        };
        init = {
          defaultBranch = "main";
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };
        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };
        help = {
          autoCorrect = "prompt";
        };
        commit = {
          verbose = true;
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        merge = {
          conflictStyle = "zdiff3";
        };

        pull = {
          rebase = true;
        };
        log = {
          date = "local";
        };
      };
    };
    vscode = {
      enable = true;
      # extensions = with pkgs.vscode-extensions; vscodeExtensions;
      profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./cursor/settings.json);
    };
    # TODO: add tmux
    # TODO: add vim
  };
  # Cursor settings
  home.file."/Users/clay/Library/Application Support/Cursor/User/settings.json".source =
    ./cursor/settings.json;
  # Cursor extensions
  home.activation.cursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    cursorExtensionCommand
  );
  # Cursor Rules
  home.file.".cursor/rules" = {
    source = ./cursor/rules;
    recursive = true;
  };
  # TODO: purge unwanted extensions by listing extensions to a list, removing wanted extensions from above, then running uninstall-extension on the rest
  # TODO: update cursor extensions after uninstall and install steps
}
