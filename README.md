# archlinux-devel

Minimal Arch Linux development images based on `archlinux:base-devel`.

## About

This project provides ready-to-use Arch development containers with `zsh`, `yay`, common CLI tools, and a non-root `dev` user with passwordless sudo.

Two image variants are built:

- `latest`: default mirror setup
- `cn`: China-friendly mirror setup with `archlinuxcn`

Published registries:

- Docker Hub: `elenoxe/archlinux-devel`
- GitHub Container Registry: `ghcr.io/elenoxe/archlinux-devel`

Published tags include:

- `latest`
- `cn`
- `sha-<commit>`
- `cn-sha-<commit>`

## Usage

Pull the default image from Docker Hub:

```bash
docker pull elenoxe/archlinux-devel:latest
```

Pull the CN variant from Docker Hub:

```bash
docker pull elenoxe/archlinux-devel:cn
```

Pull the default image from GHCR:

```bash
docker pull ghcr.io/elenoxe/archlinux-devel:latest
```

Build the default image locally:

```bash
docker build -t archlinux-devel:latest archlinux-devel
```

Build the CN image locally:

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

Build both variants with [`compose.yaml`](./compose.yaml):

```bash
docker compose build
```

Start an interactive shell:

```bash
docker run --rm -it ghcr.io/elenoxe/archlinux-devel:latest
```

Mount your workspace into the default working directory:

```bash
docker run --rm -it \
  -v "$PWD":/home/dev/workspace \
  ghcr.io/elenoxe/archlinux-devel:latest
```

## Features

- Based on `archlinux:base-devel`
- Creates a passwordless sudo user named `dev` by default
- Uses `zsh` as the default shell
- Preconfigures `zimfw` and `powerlevel10k`
- Adds the `arch4edu` repository
- Includes packages listed in [`build/packages.txt`](./build/packages.txt)

Variant details:

- `latest` keeps the standard Arch mirror configuration and uses the official `arch4edu` mirror
- `cn` replaces the main Arch mirrorlist with Chinese mirrors from [`build/pacman/mirrorlist.cn`](./build/pacman/mirrorlist.cn) and enables `archlinuxcn`
