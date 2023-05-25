#!/bin/bash

systemctl --user daemon-reload
systemctl --user stop eso-database-uploader.service
systemctl --user disable eso-database-uploader.service

echo "OK"
