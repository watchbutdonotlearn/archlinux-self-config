sudo VBoxClient --clipboard
sudo VBoxClient --draganddrop
VBoxClient-all
sudo VBoxControl sharedfolder --automount
sudo chmod 755 /media
sudo chmod 755 /media/*
sudo usermod -aG vboxsf $USER


#make journal volatile
sudo journalctl --vacuum-time=1s
echo "Storage=volatile" | sudo tee -a /etc/systemd/journald.conf
echo "RuntimeMaxUse=50M" | sudo tee -a /etc/systemd/journald.conf
sudo systemctl restart systemd-journald


echo "changes to shared folder will only take place after reboot"



