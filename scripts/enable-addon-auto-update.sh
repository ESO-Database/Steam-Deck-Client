#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

systemctl --user daemon-reload
systemctl --user enable eso-database-addon-updater.timer
systemctl --user restart eso-database-addon-updater.timer

print_success "The ESO-Database AddOn Updater Service has been enabled and started"
