#!/bin/bash

sudo curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo > /etc/yum.repos.d/tailscale.repo
systemctl enable --now tailscaled.service
sudo tailscale up --operator=buonhobo
nano .ssh/id_ed25519
ssh-keygen -y -f .ssh/id_ed25519 > .ssh/id_ed25519.pub
chmod 600 .ssh/id_ed25519*
rpm-ostree override remove gnome-software gnome-software-rpm-ostree --install cascadia-code-fonts --install ddcutil --install tailscale
rsync ./home/buonhobo /home/ -rP
sudo rsync ./etc/systemd /etc/ -rP
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.github.flxzt.rnote \
    com.github.iwalton3.jellyfin-media-player \
    com.github.tchx84.Flatseal \
    com.mattjakeman.ExtensionManager \
    com.valvesoftware.Steam \
    com.vivaldi.Vivaldi \
    dev.vencord.Vesktop \
    net.nokyan.Resources \
    org.gnome.Papers \
    org.mozilla.firefox \
    org.onlyoffice.desktopeditors \
    org.videolan.VLC \
    page.codeberg.libre_menu_editor.LibreMenuEditor
flatpak uninstall org.gnome.Evince
curl -f https://zed.dev/install.sh | sh
