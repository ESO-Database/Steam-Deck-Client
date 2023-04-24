#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl stop eso-database-uploader.service
sudo systemctl disable eso-database-uploader.service

echo "OK"
