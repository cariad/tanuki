# tanuki

Hi! I'm **[Cariad](https://cariad.io)**. I'm a **Python developer** by trade.

I run **Visual Studio Code on a MacBook Pro** (_macaroni_), and use the Remote SSH extension to **develop, run and test my code on an Intel NUC** (_tanuki_).

This project holds my **scripts and documentation** for setting up _tanuki_ from an empty box to a **remote Python development machine**.

With thanks to [@dmrz](https://github.com/dmrz) for [inspiring](https://dimamoroz.com/2021/03/09/intel-nuc-for-development/) me to finish this!

## Assumptions and requirements

This guide assumes you have a Mac running **macOS 11.0 Big Sur or later**, and that you intend to install **Ubuntu Server 20.10** onto an **Intel NUC10i5FNH NUC** (or compatible).

## Building your own _tanuki_

<span style="font-size: smaller; font-style: italic;">This list contains Amazon UK affiliate links. As an Amazon Associate, I earn from qualifying purchases.</span>

If you want to follow along, these are the parts I use:

- [Intel NUC10i5FNH NUC](https://amzn.to/3d1HEud)
- [Corsair Vengeance 32 GB RAM](https://amzn.to/3r8yqkF)
- [Samsung 980 PRO 250 GB](https://amzn.to/3ccXYcm)
- [Samsung 32 GB USB stick](https://amzn.to/3lEV7Mg)

## Prepare an SSH key pair

You'll use an SSH key pair to authenticate SSH connections from your Mac into _tanuki_.

1. On your Mac:

    ```bash
    ssh-keygen -t ed25519 -C cariad@hey.com  # Use your own email address
    ssh-add -K ~/.ssh/id_ed25519             # Add to ssh-agent to remember your passphrase
    pbcopy < ~/.ssh/id_ed25519.pub           # Copy your public key to the clipboard
    ```

1. Add your new key [to your GitHub account](https://github.com/settings/ssh/new). _The Ubuntu installer will download your key from GitHub and set up OpenSSH automatically._

## Prepare an Ubuntu USB stick

1. [Download Ubuntu Server 20.10](https://ubuntu.com/download/server#downloads). Use BitTorrent; I like [transmission/transmission](https://github.com/transmission/transmission).
1. Burn the ISO to a USB stick. I like [balena-io/etcher](https://github.com/balena-io/etcher).

## Fork and configure this project

The only file you need to edit is [identity.sh](identity.sh).

## Set up _tanuki_'s hardware

Connect _tanuki_ to a keyboard, monitor and network.

TODO: UEFI.

## Install Ubuntu

1. Install:
    1. Select your language (English UK)
    1. Offer to use later installer: accept.
    1. Identify keyboard. The default English US seems to be fine.
    1. Network. Check IPv4 DHCP is enabled.
    1. No proxy.
    1. Ensure GB mirror is prefilled.
    1. Use entire disk, but disable LVM group.
    1. Ensure the mount point has the same size as your disk.
    1. Your name: Cariad
    1. Server's name: tanuki
    1. Username: cariad
    1. Password: ********
    1. Yes to install OpenSSH server.
    1. Yes to import keys from GitHub.
    1. Allow password auth over SSH? NO.
    1. Featured snaps: disable all.


## Bootstrap

```bash
git clone https://github.com/cariad/tanuki ~/.tanuki
```

You **must** clone to `~/.tanuki` otherwise horrible things will happen.

You **must** keep `~/.tanuki` after installation otherwise terrible things will happen.

```bash
cd ~/.tanuki
./bootstrap.sh
```

## Open an SSH session

`bootstrap.sh` will make _tanuki_ available at `<SERVER NAME>.local` on your local network.

My username is "cariad" and server name is "tanuki", so I can open an SSH session with:

```bash
ssh cariad@tanuki.local
```

Disconnect your monitor and keyboard from _tanuki_ and work from an SSH session for the remaining steps.

## Install and configure all the things

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

## FAQs

### Why do you install auto-cpufreq?

Session 1:

```bash
auto-cpufreq --monitor
```

Session 2:

```bash
sudo apt install sysbench
sysbench cpu --cpu-max-prime=10000000 --threads=8 run
```

Make a note of **total time** under **General statistics**. Before: ~30 seconds. After: ~15 seconds.
