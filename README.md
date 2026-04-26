# archlinux-devel

Minimal Arch Linux development images based on `archlinux:base-devel`.

This project builds two Docker image variants:

- `archlinux-devel:latest`: default mirror setup
- `archlinux-devel:cn`: China-friendly mirror setup with `archlinuxcn`

Both variants are intended to provide a ready-to-use Arch development shell with `zsh`, `yay`, common CLI tools, and a non-root user.

## Features

- Based on `archlinux:base-devel`
- Creates a passwordless sudo user named `dev` by default
- Uses `zsh` as the default shell
- Preconfigures `zimfw` and `powerlevel10k`
- Adds the `arch4edu` repository
- Optionally switches to CN mirrors and enables `archlinuxcn`

## Included Packages

See [`build/packages.txt`](./build/packages.txt).

## Variants

### Default

The default variant keeps the standard Arch mirror configuration and uses the official `arch4edu` mirror.

### CN

The CN variant:

- replaces the main Arch mirrorlist with Chinese mirrors (see [`build/pacman//mirrorlist.cn`](./build/pacman/mirrorlist.cn))
- enables the `archlinuxcn` repository

## Build

Build the default image:

```bash
docker build -t archlinux-devel:latest archlinux-devel
```

Build the CN image:

```bash
docker build --build-arg CN=1 -t archlinux-devel:cn archlinux-devel
```

Build with a custom username:

```bash
docker build \
  --build-arg USERNAME=myuser \
  -t archlinux-devel:latest \
  archlinux-devel
```

## Docker Compose

[`compose.yaml`](./compose.yaml) defines both variants:

```bash
docker compose build
```

This produces:

- `archlinux-devel:latest`
- `archlinux-devel:cn`

## Run

Start an interactive shell:

```bash
docker run --rm -it archlinux-devel:latest
```

Mount your workspace into the default working directory:

```bash
docker run --rm -it \
  -v "$PWD":/home/dev/workspace \
  archlinux-devel:latest
```
