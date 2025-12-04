{
  lib,
  ...
}@inputs:
let
  sharedExtensions = [
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
    "ms-toolsai.jupyter"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-slideshow"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
  ];
  vscodeExtensions = [
    "github.copilot-chat"
    "github.copilot"
    "ms-python.vscode-pylance"
  ]
  ++ sharedExtensions;
  vscodeInsidersExtensions = [
    "github.copilot"
    "ms-python.vscode-pylance"
  ]
  ++ sharedExtensions;
  # cursorExtensions = [
  #   "anysphere.cursorpyright"
  #   "anysphere.pyright"
  # ]
  # ++ sharedExtensions;
  # Single-command extension management per editor to minimize CLI invocations
  manageExtensions =
    editor: desiredExtensions:
    let
      desiredExtensionsList = builtins.concatStringsSep " " desiredExtensions;
    in
    ''
      DESIRED_EXTS="${desiredExtensionsList}"
      INSTALLED_EXTS=$(${editor} --list-extensions 2>/dev/null || true)

      UNINSTALL_ARGS=""
      for ext in $INSTALLED_EXTS; do
        if ! echo " $DESIRED_EXTS " | grep -Fq " $ext "; then
          UNINSTALL_ARGS="$UNINSTALL_ARGS --uninstall-extension $ext"
        fi
      done

      INSTALL_ARGS=""
      for ext in $DESIRED_EXTS; do
        INSTALL_ARGS="$INSTALL_ARGS --install-extension $ext"
      done


      if [ -n "$INSTALL_ARGS$UNINSTALL_ARGS" ]; then
        echo "Applying extension changes for ${editor}"
        ${editor} --force $INSTALL_ARGS $UNINSTALL_ARGS || true
      else
        echo "No extension changes required for ${editor}"
      fi
    '';

  # Combined extension management commands
  # cursorExtensionCommand = manageExtensions "/opt/homebrew/bin/cursor" cursorExtensions;

  vscodeExtensionCommand = manageExtensions "/opt/homebrew/bin/code" vscodeExtensions;

  vscodeInsidersExtensionCommand = manageExtensions "/opt/homebrew/bin/code-insiders" vscodeInsidersExtensions;
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
    # wezterm = {
    #   enable = true;
    #   extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    # };

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
        pr = "gh pr create --draft --editor";
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
    ./dotfiles/vscode/settings.json;
  # home.file."/Users/clay/Library/Application Support/Code/User/mcp.json".source =
  # ./dotfiles/vscode/mcp.json;
  # Insiders settings
  home.file."/Users/clay/Library/Application Support/Code - Insiders/User/settings.json".source =
    ./dotfiles/vscode/settings.json;
  # home.file."/Users/clay/Library/Application Support/Code - Insiders/User/mcp.json".source =
  # ./dotfiles/vscode/mcp.json;
  # VSCode extensions
  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    vscodeExtensionCommand
  );
  home.activation.vscodeInsidersExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    vscodeInsidersExtensionCommand
  );
  # Cursor settings
  # home.file."/Users/clay/Library/Application Support/Cursor/User/settings.json".source =
  #   ./dotfiles/cursor/settings.json;
  # Cursor extensions
  # home.activation.cursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
  #   cursorExtensionCommand
  # );
  # Cursor Rules
  # home.file.".cursor/rules" = {
  #   source = ./dotfiles/cursor/rules;
  #   recursive = true;
  # };
  # Colima config
  home.file."/Users/clay/.colima/_templates/default.yaml".source = ./dotfiles/colima/default.yaml;
  # Ghostty config
  home.file."/Users/clay/Library/Application Support/com.mitchellh.ghostty/config".source =
    ./dotfiles/ghostty/config;
}
