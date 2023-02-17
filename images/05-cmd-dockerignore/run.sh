#!/bin/bash

echo "Starting Container ..."

echo "CONTAINER IS UP AND RUNNING!" > /var/www/html/ini.html

apachectl -DFOREGROUND
