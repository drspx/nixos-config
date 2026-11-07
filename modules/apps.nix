# System-wide programs and CLI basics for every user (and root)
{ pkgs, ... }:

{
  # Run AppImages directly: chmod +x foo.AppImage && ./foo.AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
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
}
