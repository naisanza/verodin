#!/usr/bin/env bash
#
# Create the ruby service
#

cp -av ruby-snort-connector.service /lib/systemd/system/

systemctl start ruby-snort-connector
systemctl enable ruby-snort-connector

