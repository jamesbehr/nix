{ config, pkgs, lib, ... }:

with lib;
let
  shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
  };
  cfg = config.niks.nvim;
in
{
  options.niks.nvim = { enable = mkEnableOption "Neovim"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ neovim ripgrep fzf ];

    xdg.configFile = {
      "nvim/niks.json" = {
        text = builtins.toJSON config.niks;
      };
      "nvim/init.lua" = {
        source = ./init.lua;
      };
      "nvim/lua" = {
        source = ./lua;
        recursive = true;
      };
      "nvim/after" = {
        source = ./after;
        recursive = true;
      };
    };

    programs.bash.shellAliases = shellAliases;
    programs.zsh.shellAliases = shellAliases;
  };
}
