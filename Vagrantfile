# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-jessie64"
  config.vm.box_check_update = false
  #config.disksize.size = '10GB'

  # Vagrant Host Manager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # Vagrant Plugin Cachier
  config.cache.scope = :machine
  config.cache.auto_detect = true
  config.cache.enable :apt
  config.cache.enable :gem

  # Vagrant Plugin TimeZone
  config.timezone.value = "UTC"

  config.vm.define "puppet-server" do |server|
    server.vm.hostname = "puppetserver-01.treeipe.com"
    server.hostmanager.aliases = %w(puppetserver-01.treeipe.com puppetserver-01)
    server.vm.network :private_network, ip: "10.10.13.10"
    server.vm.network "forwarded_port", guest: 8140, host: 8140

    server.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--name", "puppetserver-01.treeipe.com"]
        vb.customize ["modifyvm", :id, "--cpus", 1]
        vb.customize ["modifyvm", :id, "--groups", "/Treeipe"]
    end

    server.vm.synced_folder "./boxes/puppet-server", "/vagrant"
    server.vm.provision :shell, :path => "provision/shell/puppet-server.sh"
  end

  config.vm.define "puppet-agent-01" do |agent01|
    agent01.vm.hostname = "agent01.treeipe.com"
    agent01.hostmanager.aliases = %w(agent01.treeipe.com agent01)
    agent01.vm.network :private_network, ip: "10.10.13.11"

    agent01.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "512"]
        vb.customize ["modifyvm", :id, "--name", "agent01.treeipe.com"]
        vb.customize ["modifyvm", :id, "--cpus", 1]
        vb.customize ["modifyvm", :id, "--groups", "/Treeipe"]
    end

    agent01.vm.synced_folder "./boxes/puppet-agent", "/vagrant"
    agent01.vm.provision :shell, :path => "provision/shell/puppet-agent.sh"
  end

end
