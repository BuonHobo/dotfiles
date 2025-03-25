FROM quay.io/fedora/fedora-bootc:41

RUN curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo > /etc/yum.repos.d/tailscale.repo && \
    dnf -y install tailscale samba cockpit cockpit-files cockpit-networkmanager cockpit-ostree cockpit-podman cockpit-selinux cockpit-storaged cockpit-system && \
    dnf clean all

COPY smb.conf /usr/etc/samba/smb.conf
COPY var-home-shared.mount /usr/lib/systemd/system
COPY containers/ /usr/share/containers/systemd/
RUN mkdir -p /var/home/shared && \
    systemctl enable tailscaled.service podman-auto-update.timer var-home-shared.mount cockpit.socket smb.service
