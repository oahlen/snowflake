# This is a demonstration container image
FROM quay.io/toolbx/arch-toolbox:latest

# Base deps
RUN pacman -Syu --noconfirm vi git curl ca-certificates sudo shadow bash xz && pacman -Scc --noconfirm

# Create user
RUN useradd -m -s /bin/bash arch && echo 'arch ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/arch

# Prepare /nix for single-user install
RUN mkdir -p /nix && chown arch:arch /nix

# Disable sandbox (hostname unshare breaks in Docker) and install Nix
RUN su - arch -c 'mkdir -p ~/.config/nix && echo "sandbox = false" > ~/.config/nix/nix.conf && curl -L https://nixos.org/nix/install | sh -s -- --no-daemon'

USER arch
ENV USER=arch

# Environment for non-login shells
ENV PATH=/home/arch/.nix-profile/bin:/home/arch/.nix-profile/sbin:$PATH

# Optional: ensure profile sourcing for interactive shells
RUN echo '. ~/.nix-profile/etc/profile.d/nix.sh' >> /home/arch/.bashrc
