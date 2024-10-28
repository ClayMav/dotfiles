{ pkgs, ... }@inputs: {
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
        command_exists = "hash \"$1\" 2> /dev/null;";
        vim = "nvim";
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
    # config, ignore
    # TODO: add cursor/vscode
    # TODO: add docker
    # TODO: add tmux
    # TODO: add vim
  };
}
