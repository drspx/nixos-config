# KDE Plasma, graphics, sound, bluetooth, printing, fonts
{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "dk";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;

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
