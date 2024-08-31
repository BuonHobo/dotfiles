#!/bin/bash

sudo ostree config set sysroot.bootloader none

sudo rm /etc/yum.repos.d/{_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo,fedora-cisco-openh264.repo,google-chrome.repo,rpmfusion-nonfree*}
sudo wget --output-document /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
rpm-ostree install cascadia-code-fonts ddcutil tailscale --apply-live

# rsync ./home/buonhobo /home/ -rP
sudo rsync ./etc/systemd /etc/ -rP
sudo systemctl daemon-reload
sudo systemctl enable --now flatpak-system-update.timer
# sudo systemctl --user enable --now brew-update.timer

systemctl enable --now tailscaled.service
sudo tailscale up --operator=buonhobo

sudo mkdir /home/shared
sudo chown buonhobo:buonhobo /home/shared/

sudo tee -a /etc/fstab <<EOF
//minipc/shared /var/home/shared cifs username=buonhobo,password=assword,uid=buonhobo,gid=buonhobo,x-systemd.automount,x-systemd.requires=tailscaled.service,x-systemd.idle-timeout=60,x-systemd.mount-timeout=30 0 0
EOF

echo "Please connect to Oneplus 7T..."
read
sudo rsync -rP etc/NetworkManager /etc/
sudo nmcli connection modify OnePlus\ 7T ipv4.route-metric 99
sudo nmcli connection modify enp39s0 802-3-ethernet.wake-on-lan magic
sudo systemctl restart NetworkManager systemd-resolved.service

echo "Get ready to insert the private key in nano..."
read
nano .ssh/id_ed25519
ssh-keygen -y -f .ssh/id_ed25519 > .ssh/id_ed25519.pub
chmod 600 .ssh/id_ed25519*

curl -f https://zed.dev/install.sh | sh

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

rpm-ostree override remove gnome-software gnome-software-rpm-ostree
