# nixos-config

NixOS flake for my ThinkPad P15v (Intel, no dGPU). Lives in `~/nixos-config`, no sudo for git.

## Files

| File | What |
|------|------|
| `flake.nix` | Inputs (nixpkgs version, nixos-hardware, otpdash) and hardware modules |
| `configuration.nix` | Everything else: packages, desktop, users, services |
| `hardware-configuration.nix` | Generated disks/kernel modules. Don't edit; regenerate only if partitions change |
| `flake.lock` | Pinned versions. Commit it |

## Edit & apply

```sh
cd ~/nixos-config
nvim configuration.nix      # e.g. add a package to environment.systemPackages
nh os switch                # build + activate (asks for sudo itself)
git commit -am "add foo" && git push
```

New files must be `git add`ed before building, flakes ignore untracked files.

Find packages/options: https://search.nixos.org

Try a change without making it the boot default: `nh os test`.

## Update (every week or two)

```sh
nh os switch -u             # update flake.lock + rebuild
git commit -am "update" && git push
```

## Upgrade NixOS release (every ~6 months, May/Nov)

Change `nixos-26.05` in `flake.nix` to the new release, then `nh os switch -u`.
Never change `system.stateVersion`.

## Something broke

- Reboot and pick an older generation in the boot menu, or
- `git checkout <good-commit> -- flake.lock configuration.nix && nh os switch`

## Dotfiles

App configs live in `dotfiles/<app>` and are symlinked to `~/.config/<app>` (list in `systemd.tmpfiles.rules`).
Edit them in place, no rebuild needed. To add an app:

```sh
mv ~/.config/fish ~/nixos-config/dotfiles/fish   # move existing config into the repo
# add "fish" to the list in configuration.nix
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
