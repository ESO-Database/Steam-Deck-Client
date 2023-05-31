#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

systemctl --user daemon-reload
systemctl --user stop eso-database-addon-updater.timer
systemctl --user disable eso-database-addon-updater.timer

print_success "The ESO-Database AddOn Updater service has been disabled and stopped"
