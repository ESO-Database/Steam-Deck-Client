#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl enable eso-database-addon-updater.timer
sudo systemctl restart eso-database-addon-updater.timer

echo "OK"
