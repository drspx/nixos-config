{ pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

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

  # Desktop
  services.xserver.enable = true;
  services.xserver.xkb.layout = "dk";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true;
      FastConnectable = true;
    };
  };

  # ThinkPad BIOS/firmware updates: `fwupdmgr refresh && fwupdmgr update`
  services.fwupd.enable = true;

  users.users.drspx = {
    isNormalUser = true;
    description = "drspx";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs = {
    firefox.enable = true;
    git.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    nh = {
      enable = true;
      flake = "/home/drspx/nixos-config";
      clean.enable = true; # weekly cleanup of old generations
      clean.extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    # nix tooling
    statix
    nil
    nixfmt

    # cli
    clang
    fd
    ripgrep
    sysstat
    lsd
    tree
    unzip
    curl
    wget
    lazygit
    btop
    fish
    python3
    nodejs
    rustup
    wl-clipboard

    # gui
    wezterm
    thunderbird
    kdePackages.kate
    kdePackages.partitionmanager

    (callPackage "${inputs.otpdash}/package.nix" { })
  ];

  # Never change this after install. It is NOT the NixOS version you run.
  system.stateVersion = "26.05";
}
