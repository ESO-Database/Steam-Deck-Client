#!/bin/bash

systemctl --user daemon-reload
systemctl --user stop eso-database-addon-updater.timer
systemctl --user disable eso-database-addon-updater.timer

echo "OK"
