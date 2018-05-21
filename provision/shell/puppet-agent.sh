#!/bin/sh

if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Agent is already installed. Moving on..."
else
    sudo apt-get install -yq puppet
fi

if cat /etc/crontab | grep puppet 2> /dev/null
then
    echo "Puppet Agent is already configured. Exiting..."
else
    sudo apt-get update -yq && sudo apt-get upgrade -yq

    sudo puppet resource cron puppet-agent ensure=present user=root minute=30 \
        command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

    sudo puppet resource service puppet ensure=running enable=true

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.10.13.10	puppetserver-01.treeipe.com puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.10.13.11   agent01.treeipe.com  agent01" | sudo tee --append /etc/hosts 2> /dev/null

    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo "[agent]\nserver=puppet" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null

    sudo puppet agent --enable

    # Customize message login
    figlet -c Puppet Agent > /etc/motd

    # Custom agnoster bash
    cd /home/vagrant && \
    git clone https://github.com/powerline/fonts.git fonts && \
    cd fonts && ./install.sh
    cd /home/vagrant && \
    mkdir -p .bash/themes/agnoster-bash && \
    git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash

    wget https://gist.githubusercontent.com/avandrevitor/e559b0373dfd77fdedf419213097b5e3/raw/d46d7f96fce644ff1d496100cd90437d9354abf8/.bashrc \
     -O /tmp/.bashrc && cat /tmp/.bashrc >> /home/vagrant/.bashrc

    wget https://gist.githubusercontent.com/avandrevitor/86319d80065f35616ff914580ea59327/raw/53220a893521dd8b46955270f00adbf5d81b2bb5/.vimrc \
    -O /home/vagrant/.vimrc
fi
