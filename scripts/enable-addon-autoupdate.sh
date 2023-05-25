#!/bin/bash

systemctl --user daemon-reload
systemctl --user enable eso-database-addon-updater.timer
systemctl --user restart eso-database-addon-updater.timer

echo "OK"
