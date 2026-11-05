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

  # Intel iGPU hardware video decoding (VA-API)
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

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
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # My tools: only on my PATH
    packages = with pkgs; [
      # nix tooling
      statix
      nil
      nixfmt

      # dev
      clang
      tree-sitter # LazyVim's treesitter needs the CLI
      lazygit
      lsd
      python3
      nodejs
      rustup
      jdk # LazyVim java extra (jdtls)
      pkl
      typst

      # gui
      wezterm
      thunderbird
      kdePackages.kate
      kdePackages.partitionmanager

      (callPackage "${inputs.otpdash}/package.nix" { })
    ];
  };

  environment.shellAliases.n = "nvim";

  # Dotfiles live in ./dotfiles and are symlinked into ~/.config (edits apply instantly, no rebuild).
  # "L" never overwrites: move an existing ~/.config/<app> into ./dotfiles first.
  systemd.tmpfiles.rules =
    map (app: "L /home/drspx/.config/${app} - - - - /home/drspx/nixos-config/dotfiles/${app}")
      [
        "wezterm"
        "nvim"
      ];

  programs = {
    fish.enable = true;
    firefox.enable = true;
    git = {
      enable = true;
      config.user = {
        name = "drspx";
        email = "76571284+drspx@users.noreply.github.com";
      };
    };
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

  # Basics for every user (and root); neovim + git come from programs.* above
  environment.systemPackages = with pkgs; [
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

  # Never change this after install. It is NOT the NixOS version you run.
  system.stateVersion = "26.05";
}
