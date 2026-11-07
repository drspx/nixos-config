# System-wide programs and CLI basics for every user (and root)
{ pkgs, ... }:

{
  # Gaming / Windows apps. Bottles = Wine with a GUI (it downloads its own Wine runners).
  programs.steam.enable = true; # also turns on 32-bit graphics + controller udev rules
  programs.firefox.enable = true;
  programs.nix-ld.enable = true; # run unpatched binaries

  # Run AppImages directly: chmod +x foo.AppImage && ./foo.AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    vlc
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
}
