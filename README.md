# nixos-config

NixOS flake for my ThinkPad P15v (Intel, no dGPU). Lives in `~/nixos-config`, no sudo for git. Shell: fish, `n` = `nvim`.

## Files

| File | What |
| ------ | ------ |
| `flake.nix` | Inputs (nixpkgs version, nixos-hardware, otpdash) and hardware modules |
| `configuration.nix` | Imports the modules below + `stateVersion` |
| `modules/system.nix` | Boot, kernel, network, locale, nix settings, `nh`, firmware |
| `modules/desktop.nix` | KDE Plasma, graphics, sound, bluetooth, printing, fonts |
| `modules/apps.nix` | System-wide apps (Steam, Heroic, Bottles, VLC, Firefox, AppImage support) + CLI basics |
| `modules/docker.nix` | Docker engine, compose, Podman Desktop (GUI) |
| `modules/user.nix` | My user, personal packages, git, fish, neovim, dotfiles symlinks |
| `hardware-configuration.nix` | Generated disks/kernel modules. Don't edit; regenerate only if partitions change |
| `flake.lock` | Pinned versions. Commit it |

## Edit & apply

```sh
cd ~/nixos-config
nvim modules/apps.nix       # e.g. add a package to environment.systemPackages
nh os switch                # build + activate (asks for sudo itself)
git commit -am "add foo" && git push
```

New files must be `git add`ed before building, flakes ignore untracked files.

Find packages/options: <https://search.nixos.org>

Try a change without making it the boot default: `nh os test`.

## Rust

Rust tools are installed and updated through Nix (`rustc`, `cargo`, `rustfmt`, `clippy`, and `rust-analyzer`); no rustup is used. Check the installed tools with:

```sh
rustc --version
cargo --version
rust-analyzer --version
```

The Nix configuration also provides GCC, pkg-config, and OpenSSL for common native build requirements. For projects needing additional native libraries, add them to the project's Nix development shell. See the [NixOS Rust wiki](https://wiki.nixos.org/wiki/Rust).

## Update (every week or two)

Runs `nixos-unstable` (rolling): this updates everything (kernel, KDE, nvim, ...), no release upgrades.

```sh
nh os switch -u             # update flake.lock + rebuild
git commit -am "update" && git push
```

Update broke or won't build? Undo it and retry in a few days:

```sh
git checkout HEAD~1 -- flake.lock && nh os switch
```

Back to stable: set `nixpkgs.url` in `flake.nix` to `github:NixOS/nixpkgs/nixos-26.05`, then `nh os switch -u`.
Never change `system.stateVersion`.

Neovim plugins and language servers are not managed by Nix:

- Plugins: `:Lazy update` in nvim, then commit `dotfiles/nvim/lazy-lock.json`
- Language servers: `:Mason`, then `U`

## Something broke

- Reboot and pick an older generation in the boot menu, or
- `git checkout <good-commit> -- flake.lock configuration.nix modules && nh os switch`

## Dotfiles

App configs live in `dotfiles/<app>` and are symlinked to `~/.config/<app>` (list in `systemd.tmpfiles.rules`).
Edit them in place, no rebuild needed. To add an app:

```sh
mv ~/.config/fish ~/nixos-config/dotfiles/fish   # move existing config into the repo
# add "fish" to the list in modules/user.nix
nh os switch && git add -A && git commit -m "fish config"
```

## Cleanup

Automatic weekly via `programs.nh.clean` (keeps last 5 generations / 7 days).
Manual: `nh clean all --keep 5`.

## Firmware/BIOS updates

```sh
fwupdmgr refresh && fwupdmgr update
```

## New machine / reinstall

```sh
git clone <repo> ~/nixos-config && cd ~/nixos-config
cp /etc/nixos/hardware-configuration.nix .   # new disks = new UUIDs
git add -A
sudo nixos-rebuild switch --flake .#nixos
```
