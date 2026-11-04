{ config, pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      # For newer Bluetooth capabilities.
      Experimental = true;
      # For quicker device reconnection.
      FastConnectable = true;
    };
    settings.Policy = {
      # Power up all controllers.
      AutoEnable = true;
    };
  };
}
