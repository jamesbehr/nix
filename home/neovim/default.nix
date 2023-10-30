{ pkgs, inputs, system, ... }:

let shellAliases = {
  vi = "nvim";
  vim = "nvim";
  vimdiff = "nvim -d";
}; in
{
  home.packages = with pkgs; [ neovim ripgrep ];

  xdg.configFile = {
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
}
