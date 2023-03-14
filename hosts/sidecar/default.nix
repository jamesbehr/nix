{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      extra-platforms = x86_64-darwin
      experimental-features = nix-command flakes
    '';
  };

  services.nix-daemon.enable = true;

  # Makes nix-darwin work with zsh. Only bash is enabled by default.
  programs.zsh.enable = true;
}
