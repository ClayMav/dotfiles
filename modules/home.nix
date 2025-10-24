{
  lib,
  ...
}@inputs:
let
  vscodeExtensions = [
    "redhat.vscode-yaml"
    "charliermarsh.ruff"
    "davidanson.vscode-markdownlint"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.mypy-type-checker"
    "mikestead.dotenv"
    "tamasfe.even-better-toml"
    "github.vscode-pull-request-github"
    "ms-vscode.makefile-tools"
    "vscodevim.vim"
    "dbaeumer.vscode-eslint"
    "enkia.tokyo-night"
    "ryanluker.vscode-coverage-gutters"
    "ms-azuretools.vscode-docker"
    "google.gemini-cli-vscode-ide-companion"
    "bradlc.vscode-tailwindcss"
    "hashicorp.terraform"
    "hashicorp.hcl"
    "github.vscode-github-actions"
    "golang.go"
    "jnoortheen.nix-ide"
    "unifiedjs.vscode-mdx"
    "yoavbls.pretty-ts-errors"
    "ms-azuretools.vscode-containers"
    "ms-python.vscode-pylance"
  ];
  cursorExtensions = [
    "anysphere.cursorpyright"
    "anysphere.pyright"
  ];
  # Function to get installed extensions for a given editor
  getInstalledExtensions = editor: ''
    ${editor} --list-extensions 2>/dev/null || true
  '';

  # Function to uninstall extensions not in the desired list
  uninstallUnwantedExtensions = editor: desiredExtensions: ''
    INSTALLED_EXTS=$(${editor} --list-extensions 2>/dev/null || true)
    for ext in $INSTALLED_EXTS; do
      if ! echo "${builtins.concatStringsSep " " desiredExtensions}" | grep -q "$ext"; then
        echo "Uninstalling unwanted extension: $ext"
        ${editor} --uninstall-extension "$ext" || true
      fi
    done
  '';

  # Function to install/update desired extensions with --force
  installDesiredExtensions = editor: desiredExtensions: ''
    for ext in ${builtins.concatStringsSep " " desiredExtensions}; do
      echo "Installing/updating extension: $ext"
      ${editor} --install-extension "$ext" --force || true
    done
  '';

  # Combined extension management commands
  cursorExtensionCommand = ''
    ${uninstallUnwantedExtensions "/opt/homebrew/bin/cursor" (vscodeExtensions ++ cursorExtensions)}
    ${installDesiredExtensions "/opt/homebrew/bin/cursor" (vscodeExtensions ++ cursorExtensions)}
  '';

  vscodeExtensionCommand = ''
    ${uninstallUnwantedExtensions "/opt/homebrew/bin/code" vscodeExtensions}
    ${installDesiredExtensions "/opt/homebrew/bin/code" vscodeExtensions}
  '';
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
          zshConfigLateInit = lib.mkOrder 1500 "[ -r \"$HOME/.config/private/secrets.sh\" ] && source \"$HOME/.config/private/secrets.sh\"";
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

      ignores = [
        ".DS_Store"
        "*.sw?"
        ".attach_pid*"
      ];

      settings = {

        user = {
          name = "Clay McGinnis";
          email = "github@clay.sh";
        };
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
    };
    # TODO: add tmux
    # TODO: add vim
  };
  # VSCode settings
  home.file."/Users/clay/Library/Application Support/Code/User/settings.json".source =
    ./dotfiles/cursor/settings.json;
  # VSCode extensions
  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    vscodeExtensionCommand
  );
  # Cursor settings
  home.file."/Users/clay/Library/Application Support/Cursor/User/settings.json".source =
    ./dotfiles/cursor/settings.json;
  # Cursor extensions
  home.activation.cursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    cursorExtensionCommand
  );
  # Cursor Rules
  home.file.".cursor/rules" = {
    source = ./dotfiles/cursor/rules;
    recursive = true;
  };
  # Colima config
  home.file."/Users/clay/.colima/_templates/default.yaml".source = ./dotfiles/colima/default.yaml;
}
