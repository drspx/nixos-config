{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/desktop.nix
    ./modules/apps.nix
    ./modules/user.nix
    ./modules/docker.nix
  ];

  # Never change this after install. It is NOT the NixOS version you run.
  system.stateVersion = "26.05";
}
