# Boot, kernel, network, locale, nix itself, firmware
{ pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "vm.dirty_background_bytes" = 16777216;
      "vm.dirty_bytes" = 50331648;
    };
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
    # Run AppImages directly: chmod +x foo.AppImage && ./foo.AppImage
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    btop
    sysstat # iostat, mpstat, sar
    curl
    wget
    unzip
    tree
    fd
    ripgrep
    wl-clipboard
    pciutils # lspci
    usbutils # lsusb
    dnsutils # dig
  ];

  services = {
    # ThinkPad BIOS/firmware updates: `fwupdmgr refresh && fwupdmgr update`
    fwupd.enable = true;

    xserver.enable = true;
    xserver.xkb.layout = "dk";
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    printing.enable = true;

    flatpak.enable = true;
  };

  # Intel iGPU hardware video decoding (VA-API)
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

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

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
}
