#!/bin/bash
#crontab setup
JOB="*/2 * * * * /home/$USER/cron-nighttime-lockscreen.sh"
(crontab -l 2>/dev/null | grep -Fv "$JOB"; echo "$JOB") | crontab -




sudo mkdir -p /etc/sysctl.d/
echo "vm.swappiness = 4" | sudo tee -a /etc/sysctl.d/99-swappiness.conf
echo "kernel.sysrq = 1" | sudo tee -a /etc/sysctl.d/sysrq.conf

