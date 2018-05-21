#!/bin/sh

if ps aux | grep "puppet server" | grep -v grep 2> /dev/null
then
    echo "Puppet Server is already installed. Exiting..."
else
    # Install Puppet Server
    echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
    apt-get update -yq
    apt-get -yqt jessie-backports install "openjdk-8-jdk-headless"
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
    dpkg -i puppetlabs-release-pc1-jessie.deb && sudo rm puppetlabs-release-pc1-jessie.deb
    apt-get update -yq #&& sudo apt-get upgrade -yq
    apt-get install -yq puppetserver puppet-agent git figlet
    export PATH=/opt/puppetlabs/bin:$PATH
    sed -i 's/JAVA_ARGS=\"-Xms2g -Xmx2g -XX:MaxPermSize=256m\"/JAVA_ARGS=\"-Xms256m -Xmx256m -XX:MaxPermSize=256m\"/g' /etc/default/puppetserver
    puppet --version
    puppet cert list -a
    puppet cert generate puppetserver-01.treeipe.com --dns_alt_names=puppet
    echo "[agent]" >> /etc/puppetlabs/puppet/puppet.conf
    echo "certname = puppetserver-01.treeipe.com" >> /etc/puppetlabs/puppet/puppet.conf

    # Install some initial puppet modules on Puppet Master server
    /etc/init.d/puppetserver start

    puppet module install puppetlabs-ntp
    puppet module install puppetlabs-stdlib
    puppet module install puppetlabs-docker
    puppet module install puppetlabs-concat
    puppet module install puppetlabs-apt
    puppet module install puppetlabs-vcsrepo

    # Customize message login
    figlet -c Puppet Server > /etc/motd

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
