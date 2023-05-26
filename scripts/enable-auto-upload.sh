#!/bin/bash

source /home/deck/Applications/ESO-Database/config/config.sh
source /home/deck/Applications/ESO-Database/scripts/tools/functions.sh

systemctl --user daemon-reload
systemctl --user enable eso-database-uploader.service
systemctl --user restart eso-database-uploader.service

print_success "The ESO-Database Upload Service has been enabled and started"
