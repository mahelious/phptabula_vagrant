# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below.
# The "2" in Vagrant.configure configures the configuration version.
# Please don't change it unless you know what you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "debian/stretch64"

  # To manually check for box updates, run `vagrant box outdated`
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "devenv"
    vb.cpus = "2"
    vb.memory = "2048"
    vb.gui = false
  end

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "private_network", ip: "10.10.0.2"

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./sites-enabled", "/etc/nginx/sites-enabled", type: "virtualbox", mount_options: ["dmode=777,fmode=777"]
  #config.vm.synced_folder "../src", "/var/www/devenv", type: "virtualbox", mount_options: ["dmode=777,fmode=777"]

  config.vm.provision :shell, :path => "./provision.sh"
  config.vm.provision :shell, :inline => "sudo service nginx restart", :run => "always"

end
