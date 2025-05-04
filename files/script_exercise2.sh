#!/bin/bash
nc -z 192.168.1.133 80 && test -f /var/www/html/index.nginx-debian.html
