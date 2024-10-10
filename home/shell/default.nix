{ pkgs, lib, config, ... }:

with lib;
let user = config.niks.user;
in
{
  options.niks.user = {
    name = mkOption {
      type = types.str;
      description = "The user's name";
    };

    email = mkOption {
      type = types.str;
      description = "The user's email address";
    };
  };

  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    home.file = {
      ".local/bin" = {
        source = ./bin;
        recursive = true;
      };
    };

    home.shellAliases = {
      g = "gitdefault";
      v = "visual";
      e = "editor";
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          extraOptions = {
            IgnoreUnknown = "UseKeyChain";
            UseKeychain = "yes";
          };
        };
      };
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      history = {
        extended = true;
        expireDuplicatesFirst = true;
      };
      defaultKeymap = "viins";
      initExtra = ''
        # Allow backspace/CTRL-H to delete past the point insert mode was entered
        bindkey -M viins '^?' backward-delete-char
        bindkey -M viins '^H' backward-delete-char

        # Press v to edit command line in text editor
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd v edit-command-line
      '';
    };

    programs.bat.enable = true;
    programs.zoxide.enable = true;
    programs.fzf.enable = true;
    programs.jq.enable = true;

    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      escapeTime = 0;
      baseIndex = 1;
      keyMode = "vi";
      extraConfig = ''
        bind-key -r ^ last-window
        bind-key -r k select-pane -U
        bind-key -r j select-pane -D
        bind-key -r h select-pane -L
        bind-key -r l select-pane -R

        bind-key -r C-w display-popup -E -E "tmux-switcher find_workspace"
        bind-key -r C-r run-shell "tmux-switcher goto_root"
        bind-key -r C-f display-popup -E -E "tmux-switcher find_project"
        bind-key -r C-h run-shell "tmux-switcher jump_project 1"
        bind-key -r C-j run-shell "tmux-switcher jump_project 2"
        bind-key -r C-k run-shell "tmux-switcher jump_project 3"
        bind-key -r C-l run-shell "tmux-switcher jump_project 4"
        bind-key -r C-n run-shell "tmux-switcher goto_project notes"

        source-file ${pkgs.vimPlugins.nightfox-nvim}/extra/duskfox/duskfox.tmux
      '';
    };

    home.packages = with pkgs; [ git-open unzip p7zip ffmpeg tree age killall graphviz imagemagick asciinema yq-go ];

    programs.git = {
      enable = true;
      userEmail = user.email;
      userName = user.name;
      aliases = {
        co = "checkout";
        cof = "fuzzy-checkout";
        ci = "commit";
        di = "diff";
        dc = "diff --cached";
        fa = "fetch --all";
        pf = "push --force-with-lease";
        cl = "clone";
        clr = "clone-to-repos";
        wtaf = "in-chosen-repo worktree add";
        amend = "commit --amend";
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        merge = {
          ff = "only";
        };
        pull = {
          rebase = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        commit = {
          verbose = true;
        };
        diff = {
          tool = "vimdiff";
        };

        # Clone shorthands e.g. git clone gh:NixOS/nix -> git clone ssh://git@github.com/NixOS/nix
        url = {
          "ssh://git@github.com/" = {
            insteadOf = [ "github:" "gh:" "git://github.com/" ];
          };
        };
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
      };
    };

    programs.readline = {
      enable = true;
      extraConfig = ''
        set editing-mode vi

        set keymap vi-insert
        Control-l: clear-screen

        set keymap vi-command
        "daw": "lbdW"
        "yaw": "lbyW"
        "caw": "lbcW"
        "diw": "lbdw"
        "yiw": "lbyw"
        "ciw": "lbcw"
        "da\"": "lF\"df\""
        "di\"": "lF\"lmtf\"d`t"
        "ci\"": "di\"i"
        "ca\"": "da\"i"
        "da'": "lF'df'"
        "di'": "lF'lmtf'd`t"
        "ci'": "di'i"
        "ca'": "da'i"
        "da`": "lF\`df\`"
        "di`": "lF\`lmtf\`d`t"
        "ci`": "di`i"
        "ca`": "da`i"
        "da(": "lF(df)"
        "di(": "lF(lmtf)d`t"
        "ci(": "di(i"
        "ca(": "da(i"
        "da)": "lF(df)"
        "di)": "lF(lmtf)d`t"
        "ci)": "di(i"
        "ca)": "da(i"
        "da{": "lF{df}"
        "di{": "lF{lmtf}d`t"
        "ci{": "di{i"
        "ca{": "da{i"
        "da}": "lF{df}"
        "di}": "lF{lmtf}d`t"
        "ci}": "di}i"
        "ca}": "da}i"
        "da[": "lF[df]"
        "di[": "lF[lmtf]d`t"
        "ci[": "di[i"
        "ca[": "da[i"
        "da]": "lF[df]"
        "di]": "lF[lmtf]d`t"
        "ci]": "di]i"
        "ca]": "da]i"
        "da<": "lF<df>"
        "di<": "lF<lmtf>d`t"
        "ci<": "di<i"
        "ca<": "da<i"
        "da>": "lF<df>"
        "di>": "lF<lmtf>d`t"
        "ci>": "di>i"
        "ca>": "da>i"
      '';
    };

    # Lorri via Home Manager doesn't work on macOS, and is instead handled by Nix
    # Darwin
    services.lorri.enable = pkgs.stdenv.isLinux;

    programs.direnv.enable = true;
  };
}
