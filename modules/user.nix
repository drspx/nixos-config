# My user: shell, personal packages, git, neovim, dotfiles
{ pkgs, inputs, ... }:

{
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
      telegram-desktop
      kdePackages.kate
      kdePackages.partitionmanager

      (callPackage "${inputs.otpdash}/package.nix" { })
    ];
  };

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      config.user = {
        name = "drspx";
        email = "76571284+drspx@users.noreply.github.com";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
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
}
