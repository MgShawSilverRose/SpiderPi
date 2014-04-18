#!/bin/bash
#*******************************************************************************
#
# setApachePort
#
# Purpose:
#
#  Reconfigure the default listener port on an Apache2 installation from port 80
#  to port 8080
#
# Files Affected:
#    /etc/apache2/ports.conf
#    /etc/apache2/sites-available/default
#
# Files Created:
#    /etc/apache2/ports.conf.spiderpi.orig
#    /etc/apache2/sites-available/default.spiderpi.orig
#
# (C) 2014 SilverRose Systems Ltd.
# License:  GNU Lesser GPL
# 
#  https://www.gnu.org/licenses/lgpl.html
#
# WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING   
#
# THIS SCRIPT IS ONLY INTENDED TO BE RUN ONCE.  RUNNING IT MULTIPLE TIMES 
# CAN CORRUPT YOUR APACHE2 WEB SERVER CONFIGURATION
# 
#*******************************************************************************
alreadySet=`grep \*:8080 /etc/apache2/ports.conf | wc -l`
if [ $alreadySet -ne 0 ]; then
    echo "/etc/apache2/ports.conf already set to port 8080"
else
    cp /etc/apache2/ports.conf /etc/apache2/ports.conf.spiderpi.orig
    cp /etc/apache2/ports.conf /etc/apache2/ports.conf.working
    sed 's/^NameVirtualHost \*:80/NameVirtualHost \*:8080/' /etc/apache2/ports.conf.working > /etc/apache2/ports.conf.working.1
    sed 's/^Listen 80/Listen 8080/' /etc/apache2/ports.conf.working.1 > /etc/apache2/ports.conf.working.2
    if [ -e /etc/apache2/ports.conf ]; then
        rm -f /etc/apache2/ports.conf
    fi
    mv -f /etc/apache2/ports.conf.working.2 /etc/apache2/ports.conf
    /bin/rm -f /etc/apache2/ports.conf.workin*
fi
#
# Now Update sites-available/default to be on port 80
#
alreadySet=`grep \*:8080 /etc/apache2/sites-available/default | wc -l`
if [ $alreadySet -ne 0 ]; then
    echo "/etc/apache2/sites-available/default already set to port 8080"
    exit 1
else
    cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.spiderpi.orig
    sed 's/VirtualHost \*:80/VirtualHost \*:8080/' /etc/apache2/sites-available/default > /etc/apache2/sites-available/default.working.1
    if [ -e /etc/apache2/sites-available/default ]; then
    rm -f /etc/apache2/sites-available/default
 fi
  mv -f /etc/apache2/sites-available/default.working.1 /etc/apache2/sites-available/default
fi
exit 0
