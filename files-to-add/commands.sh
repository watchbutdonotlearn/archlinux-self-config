#!/bin/bash

# Install packages
sudo pacman -Syy
sudo pacman -S git 7zip fakeroot debugedit kitty vim tmux openssh
chmod +x aurhelper
chmod +x venvmake


read -p "Install plasma-meta right now? Say yes if you forgot to do it during arch installation (y/n) " answer

case "$answer" in
  y|Y)
    #in case you forgot
    sudo pacman -S plasma-meta
    ;;
  n|N)
    echo "not installing plasma-meta."
    ;;
  *)
    echo "Invalid response. Please enter 'y' or 'n'."
    ;;
esac

sudo pacman -S ark dolphin kate ecryptfs-utils

# Install LibreWolf
gpg --keyserver hkp://keyserver.ubuntu.com --search-keys 662E3CDD6FE329002D0CA5BB40339DD82B12EF16
./aurhelper install librewolf-bin

# Install Opensnitch
sudo pacman -S opensnitch
./aurhelper install opensnitch-ebpf-module
sudo systemctl enable opensnitchd
# sudo systemctl start opensnitchd

# Install WMI Battery
read -p "Is this computer an Acer device? (y/n) " answer

case "$answer" in
  y|Y)
    # Install the script if user answers yes
    git clone https://github.com/frederik-h/acer-wmi-battery.git
    cd acer-wmi-battery
    make
    sudo insmod acer-wmi-battery.ko enable_health_mode=1
    echo "Acer WMI Battery module installed."
    # i think i remember this being an issue
    # sudo pacman -S sof-firmware
    ;;
  n|N)
    echo "not installing Acer WMI battery module."
    ;;
  *)
    echo "Invalid response. Please enter 'y' or 'n'."
    ;;
esac


# Enable DNS over HTTPS
sudo pacman -S dns-over-https
sudo systemctl enable doh-client.service
sudo systemctl start doh-client.service
sudo bash -c "echo 'nameserver 127.0.0.1' > /etc/resolv.conf"

# Configure NetworkManager to avoid modifying resolv.conf
sudo bash -c "echo -e '[main]\ndns=none\nsystemd-resolved=false' > /etc/NetworkManager/conf.d/dns.conf"


# Enable MAC address randomization
sudo systemctl restart NetworkManager
sudo bash -c "echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=stable\nwifi.cloned-mac-address=stable' > /etc/NetworkManager/conf.d/30-mac-config.conf"




# Remove bloat packages
sudo pacman -Rdd discover plasma-browser-integration
sudo chmod -R 444 /home/bobbert/.local/share/kactivitymanagerd/


# Absolute essential on arch
# sudo pacman -S neofetch
# install other packages too
#sudo pacman -S python-pip


# Install TLP
# read -p "Is this computer a laptop? If yes, this script will install TLP (y/n) " tlpanswer
#
# case "$tlpanswer" in
#   y|Y)
#     # Install the script if user answers yes
#     sudo pacman -S tlp
#     sudo systemctl enable tlp.service
#     sudo systemctl mask systemd-rfkill.service
#     sudo systemctl mask systemd-rfkill.socket
#     echo "TLP installed."
#     ;;
#   n|N)
#     echo "Installation of TLP cancelled."
#     ;;
#   *)
#     echo "Invalid response. Please enter 'y' or 'n'."
#     ;;
# esac




read -p "Is this computer a laptop? If yes, this script will install TuneD (y/n) " tlpanswer

case "$tlpanswer" in
  y|Y)
    # Install the script if user answers yes
    sudo pacman -S tuned tuned-ppd
    ;;
  n|N)
    echo "Installation of TuneD cancelled."
    ;;
  *)
    echo "Invalid response. Please enter 'y' or 'n'."
    ;;
esac





read -p "Is this computer a virtual machine in virtualbox? If yes, this script will install virtualbox guest (y/n) " tlpanswer

case "$tlpanswer" in
  y|Y)
    # Install the script if user answers yes
    sudo pacman -S virtualbox-guest-utils
    sudo systemctl enable vboxservice.service
    sudo VBoxClient --clipboard
    sudo VBoxClient --draganddrop
    ;;
  n|N)
    echo "Installation of virtualbox guest utils cancelled."
    ;;
  *)
    echo "Invalid response. Please enter 'y' or 'n'."
    ;;
esac


#fonts
sudo pacman -S ttf-liberation


# /etc/hosts
sudo mv ./hosts /etc/hosts
# enable sysrq
sudo mkdir -p /etc/sysctl.d/
sudo mv ./sysrq.conf /etc/sysctl.d/sysrq.conf

sudo mkdir -p /etc/NetworkManager/conf.d/
sudo mv ./20-connectivity.conf /etc/NetworkManager/conf.d/20-connectivity.conf

mkdir -p ~/.local/share/kxmlgui5/dolphin/
mv ./dolphinui.rc ~/.local/share/kxmlgui5/dolphin/dolphinui.rc


unzip unix-local.zip


chmod +x ./after-first-boot-virtualbox.sh
chmod +x ./other-setup.sh


cat bashrc-additions.txt >> ~/.bashrc



echo "ProcessSizeMax=500M" | sudo tee -a /etc/systemd/coredump.conf
echo "MaxUse=600M" | sudo tee -a /etc/systemd/coredump.conf



balooctl suspend
balooctl disable


echo "reboot after this for most changes to take effect"
echo "manual actions required: import opensnitch rules"
echo "if this is a virtualbox VM, run after-first-boot-virtualbox.sh after reboot"
echo "if this is a normal pc, run other-setup.sh"
