{
  inputs = {
    # Rolling release. Back to stable: "github:NixOS/nixpkgs/nixos-26.05", then `nh os switch -u`.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          (nixos-hardware + "/lenovo/thinkpad/p15v")
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
        ];
      };
    };
}
