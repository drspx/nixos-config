# Docker engine + compose. `docker compose` and `docker-compose` both work.
{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.drspx.extraGroups = [ "docker" ]; # docker without sudo; log out/in once after first switch

  environment.systemPackages = with pkgs; [
    docker-compose
    # ponytail: Docker Desktop isn't packaged for NixOS; Podman Desktop is the GUI that talks to the Docker socket
    podman-desktop
  ];
}
