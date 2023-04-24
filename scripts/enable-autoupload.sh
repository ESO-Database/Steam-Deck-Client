#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl enable eso-database-uploader.service
sudo systemctl restart eso-database-uploader.service

echo "OK"
