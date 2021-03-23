# tanuki: Set up an Intel NUC for remote Visual Studio Code Python development

[![tanuki](https://github.com/cariad/tanuki/actions/workflows/ci.yml/badge.svg)](https://github.com/cariad/tanuki/actions/workflows/ci.yml)

Hi! I'm [Cariad](https://cariad.io), and I'm a freelance Python developer by trade.

I run Visual Studio Code on a MacBook Pro (aka _macaroni_) and use the Remote SSH extension to develop, test and run my code on an Intel NUC (aka _tanuki_).

This project holds my scripts for building _tanuki_ up from an empty box to a remote Python development machine.

With thanks to [@dmrz](https://github.com/dmrz) for [inspiring](https://dimamoroz.com/2021/03/09/intel-nuc-for-development/) me to finish this!

## What does it do?

### Installs:

- `aws`
- `docker`
- `pipenv`
- `pyenv`
- `python` 3.9

### Creates:

- SSH key pair for authenticating with GitHub, GitLab et al.
- GPG key pair for signing git commits.

### Configures:

- GitHub and GitLab as trusted hosts
- git name and email address

### Enables:

- Commit signing
- CPU performance mode
- Local domain name at `<SERVER NAME>.local`

## Build your own _tanuki_

_This list contains Amazon UK affiliate links. As an Amazon Associate, I earn from qualifying purchases._

If you want to follow along, these are the parts I use:

- [Intel NUC10i5FNH NUC](https://amzn.to/3d1HEud)
- [Corsair Vengeance 32 GB RAM](https://amzn.to/3r8yqkF)
- [Samsung 980 PRO 250 GB](https://amzn.to/3ccXYcm)
- [Samsung 32 GB USB stick](https://amzn.to/3lEV7Mg)

## Prepare an SSH key pair

You'll need an SSH key pair to authenticate SSH sessions from your Mac into _tanuki_.

1. On your Mac:

    ```bash
    ssh-keygen -t ed25519 -C cariad@hey.com  # Use your own email address
    ssh-add -K ~/.ssh/id_ed25519             # Add to ssh-agent to remember your passphrase
    pbcopy < ~/.ssh/id_ed25519.pub           # Copy your public key to the clipboard
    ```

1. Add your new key [to your GitHub account](https://github.com/settings/ssh/new). _The Ubuntu installer will download your key from GitHub and set up OpenSSH for you._

## Prepare an Ubuntu USB stick

1. [Download Ubuntu Server 20.10](https://ubuntu.com/download/server#downloads). _Use BitTorrent; I like [transmission/transmission](https://github.com/transmission/transmission)._
1. Burn the ISO to a USB stick. _I like [balena-io/etcher](https://github.com/balena-io/etcher)._

## Configuration

To run this script yourself, fork the project then edit your [identity.sh](identity.sh).

## Set up _tanuki_'s hardware

1. Connect _tanuki_ to a keyboard, monitor and network.
1. Turn it on and hammer `F2` to open the UEFI menu.
1. Press `F9` to load optimised defaults.
1. Change:
    - **Advanced / Onboard devices / HD audio:** _disable_
    - **Advanced / Onboard devices / Digital microphone:** _disable_
    - **Advanced / Onboard devices / WLAN:** _disable_
    - **Advanced / Onboard devices / Bluetooth:** _disable_
    - **Advanced / Onboard devices / HDMI CEC control:** _disable_
    - **Cooling / Fan control mode:** _Cool_
1. Press `F10` to save and exit the UEFI menu.

## Install Ubuntu

1. Plug in the USB stick, then reboot and hammer `F10` to open the boot menu. Boot from the USB stick.
1. During the Ubuntu installation wizard, choose the default options with these exceptions:
    - **Partition the entire disk** but _do not_ use an LVM group. _LVM will partition only half of your SSD._
    - **Enable OpenSSH**. When prompted, import your public SSH key from GitHub. Do not allow password authentication over SSH.
    - Do not install any **featured snaps**.

## Bootstrap

`bootstrap.sh` is a lightweight script to enable _tanuki_'s local domain name so subsequent steps can be easily run in an SSH session.

On _tanuki_:

```bash
git clone https://github.com/cariad/tanuki ~/.tanuki
cd ~/.tanuki
./bootstrap.sh
```

**Terrible things** will happen if you:

- Clone to anywhere other than `~/.tanuki`
- Ever delete `~/.tanuki`

## Install and configure all the things

Open an SSH session from your Mac:

```bash
ssh cariad@tanuki.local
```

Run `setup.sh` on _tanuki_:

```bash
cd ~/.tanuki
./setup.sh
```

## Finalising

### SSH authentication

`setup.sh` will output a public SSH key which allows _tanuki_ to authenticate with services like GitHub and GitLab without passwords.

You must add the public SSH key to GitHub, GitLab et al yourself.

### Commit signing

`git` will be configured to sign commits, but you must enable it in Visual Studio Code if you commit via the Command Palette.

Set `git.enableCommitSigning` to `true`.

`setup.sh` will also output a GPG key which must be added to GitHub, GitLab et al for your signature to be recognised.

## Hello there! 🎉

My name's **Cariad**, and I'm an [freelance DevOps engineer](https://cariad.io).

I'd love to spend more time working on open source projects, but I need to chase gigs that pay the rent. If this project has value to you, please consider [☕️ sponsoring](https://github.com/sponsors/cariad) me.

Thank you! ❤️
