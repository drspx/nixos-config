# Boot, kernel, network, locale, nix itself, firmware
{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = 16777216;
    "vm.dirty_bytes" = 50331648;
  };

  networking.hostName = "nixos"; # must match nixosConfigurations.<name> in flake.nix
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };
  console.keyMap = "dk-latin1";

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  programs = {
    nh = {
      enable = true;
      flake = "/home/drspx/nixos-config";
      clean.enable = true; # weekly cleanup of old generations
      clean.extraArgs = "--keep 5 --keep-since 7d";
    };
    usbtop.enable = true;
  };

  # ThinkPad BIOS/firmware updates: `fwupdmgr refresh && fwupdmgr update`
  services.fwupd.enable = true;
}
