{ pkgs, lib, ... }@inputs:
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
  ];
  cursorExtensionCommands = builtins.map (ext: "/opt/homebrew/bin/cursor --install-extension ${ext}") vscodeExtensions;
in
{
  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "24.05";

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
      initExtra = builtins.readFile ./dotfiles/zsh/.zshrc;

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
        plugins = [ "git" "docker" "tmux" ];
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
        };
        pull = { rebase = true; };
        push = { autoSetupRemote = true; };
        log = { date = "local"; };
      };
    };
    vscode = {
      enable = true;
      # extensions = with pkgs.vscode-extensions; vscodeExtensions;
      userSettings = builtins.fromJSON (builtins.readFile ./cursor/settings.json);
    };
    # TODO: add tmux
    # TODO: add vim
  };
  # Cursor settings
  home.file."/Users/clay/Library/Application Support/Cursor/User/settings.json".source = ./cursor/settings.json;
  # Cursor extensions
  home.activation.cursorExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    builtins.concatStringsSep "\n" cursorExtensionCommands
  );
}
