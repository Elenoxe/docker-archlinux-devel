FROM archlinux:base-devel

ARG CN=0
ARG USERNAME=dev

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY files/system/ /

ENV LANG=en_US.UTF-8

# System setup: configure repos, bootstrap keyrings, install base packages.
RUN --mount=type=bind,source=build,target=/tmp/build,ro \
  set -eux; \
  if [[ "${CN}" != "0" && "${CN}" != "1" ]]; then \
  printf 'CN must be 0 or 1, got: %s\n' "${CN}" >&2; \
  exit 2; \
  fi; \
  pacman-key --init; \
  pacman-key --populate archlinux; \
  pacman-key --recv-keys 7931B6D628C8D3BA; \
  pacman-key --lsign-key 7931B6D628C8D3BA; \
  if [[ "${CN}" == "1" ]]; then \
  cat /tmp/build/pacman/arch4edu.cn.repo >> /etc/pacman.conf; \
  printf '\n' >> /etc/pacman.conf; \
  pacman -Sy --noconfirm arch4edu-keyring; \
  install -m 0644 /tmp/build/pacman/mirrorlist.cn /etc/pacman.d/mirrorlist; \
  cat /tmp/build/pacman/archlinuxcn.repo >> /etc/pacman.conf; \
  printf '\n' >> /etc/pacman.conf; \
  pacman -Sy --noconfirm archlinuxcn-keyring; \
  else \
  cat /tmp/build/pacman/arch4edu.repo >> /etc/pacman.conf; \
  printf '\n' >> /etc/pacman.conf; \
  pacman -Sy --noconfirm arch4edu-keyring; \
  fi; \
  pacman -Syu --noconfirm --needed $(sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' /tmp/build/packages.txt); \
  printf 'y\ny\n' | pacman -Scc; \
  rm -rf /var/lib/pacman/sync/*; \
  locale-gen

# User setup: create the user and install its home files.
RUN --mount=type=bind,source=build,target=/tmp/build,ro \
  set -eux; \
  useradd --create-home --uid 1000 --user-group --shell /bin/zsh "${USERNAME}"; \
  sed "s/^dev\\b/${USERNAME}/" /tmp/build/sudoers.nopasswd > "/etc/sudoers.d/${USERNAME}"; \
  chmod 0440 "/etc/sudoers.d/${USERNAME}"

COPY --chown=${USERNAME}:${USERNAME} files/home/ /home/${USERNAME}/

# Shell setup: install zimfw, source zsh config to preinstall modules, then clean caches.
RUN set -eux; \
  runuser -u "${USERNAME}" -- yay -S --noconfirm --needed zimfw; \
  runuser -u "${USERNAME}" -- zsh -lc 'source ~/.zshrc'; \
  runuser -u "${USERNAME}" -- sh -lc '$HOME/.zim/modules/powerlevel10k/gitstatus/install'; \
  rm -rf /var/cache/pacman/pkg/download-*; \
  runuser -u "${USERNAME}" -- sh -lc "printf 'y\ny\n' | yay -Scc"; \
  rm -rf /home/${USERNAME}/.cache/yay; \
  rm -rf /var/lib/pacman/sync/*


USER ${USERNAME}
WORKDIR /home/${USERNAME}
CMD ["/bin/zsh"]
