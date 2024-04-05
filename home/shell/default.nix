{ pkgs, lib, inputs, system, config, ... }:

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
      # TODO: Theme
    };

    home.packages = with pkgs; [ git-open unzip p7zip ffmpeg tree age killall graphviz imagemagick asciinema yq-go ];

    programs.git = {
      enable = true;
      userEmail = user.email;
      userName = user.name;
      aliases = {
        co = "checkout";
        ci = "commit";
        di = "diff";
        dc = "diff --cached";
        fa = "fetch --all";
        pf = "push --force-with-lease";
        cl = "clone";
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
