{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/user.nix
    ./modules/docker.nix
    ./modules/exclude.nix
  ];

  nixpkgs.overlays = [ (import ./overlays/lutris.nix) ];

  # Never change this after install. It is NOT the NixOS version you run.
  system.stateVersion = "26.05";
}
