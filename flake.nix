{
  inputs = {
    # Bump to the next release (e.g. nixos-26.11) when it's out, then `nix flake update`.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    otpdash = {
      url = "github:drspx/otpdash";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, nixos-hardware, ... }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          # Intel-only P15v (no dGPU): generic modules; the p15v-gen3 profile forces NVIDIA.
          nixos-hardware.nixosModules.lenovo-thinkpad
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    };
}
