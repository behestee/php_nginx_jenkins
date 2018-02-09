# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "bento/ubuntu-16.04-i386"
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", ip: "192.168.10.10"
  config.vm.provision :shell, path: "provision.sh"

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  #config.vm.synced_folder ".", "/var/www", create: true, group: "www-data", owner: "www-data"

  
end
