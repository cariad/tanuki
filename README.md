# tanuki

Setup script for tanuki; my Intel NUC development box

## Build

TODO: link to components, including USB stick.

## Prepare an SSH key pair

We'll use an SSH key pair to authenticate SSH connections into tanuki.

The public key will be published on GitHub so the Ubuntu installer can download it and set up OpenSSH for us. Your private SSH key never needs to be copied to tanuki.

Skip this if you already have an SSH key pair.

### Create an SSH key pair

On your Mac, replacing my email address for yours:

```bash
ssh-keygen -t ed25519 -C cariad@hey.com
```

Add your key to `ssh-agent` to remember your passphrase for you:

```bash
ssh-add -K ~/.ssh/id_ed25519
```

Copy your public key to the clipboard:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Go to [your GitHub keys](https://github.com/settings/keys), click **New SSH key** then paste in your public key from the clipboard. Make the title meaningful to you, but don't sweat it.

### Backing up your keys

1. Copy `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub` to a safe place.
1. Commit your passphrase to memory.

### Restoring your keys from a backup

1. Copy `id_ed25519` and `id_ed25519.pub` into `~/.ssh`.
1. Run:

    ```bash
    ssh-add -K ~/.ssh/id_ed25519
    ```

## Prepare a GPG key

We'll use a GPG key to sign our git commits. Skip this if you already have a GPG key.

1. [Download](https://gpgtools.org/) and install GPG Suite. If you plan on only using `gpg` on the command-line then customise the installation to disable **GPG Mail** and **GPG Services**.

![Customised GPG Suite installation](docs/install-gpg-suite.png)

1. Run:

    ```bash
    gpg --generate-key
    ```

## Prepare an Ubuntu USB stick

1. [Download Ubuntu Server 20.10](https://ubuntu.com/download/server#downloads). Use BitTorrent; I like [transmission/transmission](https://github.com/transmission/transmission).
1. Burn the ISO to a USB stick. I like [balena-io/etcher](https://github.com/balena-io/etcher).

## Set up _tanuki_'s hardware

Connect _tanuki_ to a keyboard, monitor and network.

UEFI.

## Install Ubuntu

TODO:

On the NUC:

```bash
git clone https://github.com/cariad/tanuki ~/.tanuki
cd ~/.tanuki
./bootstrap.sh
```

## Copy GPG key

On your Mac:

```bash
./upload-gpg-key.sh -host tanuki5.local -host-user cariad -key cariad@hey.com
```

## Run setup

SSH in and run:

```bash
ssh cariad@tanuki5.local
cd ~/.tanuki
./setup.sh
```

## OPTIONAL: Test CPU scaling

Run:

```bash
sudo apt install sysbench
sysbench cpu --cpu-max-prime=10000000 --threads=8 run
```

Make a note of **total time** under **General statistics**. It could be ~30 seconds.

## Setup

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
1. Wait, then reboot.
1. Login.

On your Mac:

```bash
git clone https://github.com/cariad/tanuki ~
~/share-gpg-key.sh -key cariad@hey.com -host tanuki3.local -host-user cariad
ssh cariad@tanuki3.local
~/.tanuki/setup.sh
```

## OPTIONAL: Verify CPU scaling

Run:

```bash
sysbench cpu --cpu-max-prime=10000000 --threads=8 run
```

Compare **total time** to the total you recorded earlier. It _should_ be significantly faster; ~15 seconds.
