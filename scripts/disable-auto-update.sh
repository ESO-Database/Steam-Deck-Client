#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

systemctl --user daemon-reload
systemctl --user stop eso-database-updater.timer
systemctl --user disable eso-database-updater.timer

print_success "The ESO-Database Updater service has been disabled and stopped"
