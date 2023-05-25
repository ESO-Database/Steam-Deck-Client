#!/bin/bash

systemctl --user daemon-reload
systemctl --user enable eso-database-uploader.service
systemctl --user restart eso-database-uploader.service

echo "OK"
