#!/bin/bash

#sudo systemctl daemon-reload
#sudo systemctl stop eso-database-addon-updater.timer
#sudo systemctl disable eso-database-addon-updater.timer
systemctl --user daemon-reload
systemctl --user stop eso-database-addon-updater.timer
systemctl --user disable eso-database-addon-updater.timer

echo "OK"
