#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

systemctl --user daemon-reload
systemctl --user stop eso-database-uploader.service
systemctl --user disable eso-database-uploader.service

print_success "The ESO-Database upload service has been disabled and stopped"
