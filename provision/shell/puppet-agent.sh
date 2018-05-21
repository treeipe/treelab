#!/bin/sh

if ps aux | grep "puppet-agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Server is already installed. Exiting..."
else
    # Install Puppet Server

fi
