#!/bin/bash

sudo ostree config set sysroot.bootloader none

sudo tee -a /etc/rpm-ostreed.conf <<EOF
AutomaticUpdatePolicy=stage
EOF
sudo systemctl enable --now rpm-ostreed-automatic.timer

sudo rm /etc/yum.repos.d/{_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo,fedora-cisco-openh264.repo,google-chrome.repo,rpmfusion-nonfree*}
sudo wget --output-document /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
rpm-ostree install cascadia-code-fonts ddcutil tailscale --apply-live

sudo rsync ./etc/udev /etc/ -rP
udevadm control --reload-rules && udevadm trigger

rsync ./home/buonhobo /home/ -rP
sudo rsync ./etc/systemd /etc/ -rP
sudo systemctl daemon-reload
sudo systemctl enable --now flatpak-system-update.timer
# sudo systemctl --user enable --now brew-update.timer

sudo systemctl enable --now tailscaled.service
sudo tailscale up --operator=buonhobo

sudo mkdir /home/shared
sudo chown buonhobo:buonhobo /home/shared/

sudo tee -a /etc/fstab <<EOF
//minipc/shared /var/home/shared cifs username=buonhobo,password=assword,uid=buonhobo,gid=buonhobo,x-systemd.automount,x-systemd.requires=tailscaled.service,x-systemd.idle-timeout=60,x-systemd.mount-timeout=30 0 0
EOF

echo "Please connect to Oneplus 7T..."
read
sudo nmcli connection modify OnePlus\ 7T ipv4.route-metric 99
sudo nmcli connection modify enp39s0 802-3-ethernet.wake-on-lan magic
sudo nmcli connection modify enp39s0 ipv4.dns 8.8.8.8,8.8.4.4
sudo nmcli connection modify enp39s0 ipv4.ignore-auto-dns yes
sudo systemctl restart NetworkManager systemd-resolved.service

echo "Get ready to insert the private key in nano..."
read
nano ~/.ssh/id_ed25519
echo "Please insert the private key password..."
chmod 400 ~/.ssh/id_ed25519

curl -f https://zed.dev/install.sh | sh

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub \
    com.github.flxzt.rnote \
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
sudo flatpak uninstall org.gnome.Evince

sudo rpm-ostree override remove gnome-software gnome-software-rpm-ostree
