# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "geerlingguy/ubuntu1804"
  config.vm.hostname = "vargrant"
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.network "forwarded_port", guest: 3306, host: 3309
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  
  config.vm.synced_folder "html", "/var/www/html",  owner: "vagrant", group: "www-data", mount_options: ['dmode=777','fmode=776']
  
  config.vm.provider "virtualbox" do |machine|
    machine.gui = false
    machine.memory = 512
    machine.cpus = 1
    machine.name = "ubuntu-server-php"
    machine.customize [
      "modifyvm", :id,
      "--cpuexecutioncap", "50",
      "--memory", "512",
    ]
    machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    machine.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "shell" do |s|
		s.path = "provision/setup.sh"
		s.env = {
			"DB_ROOT_PASSWORD" => "admin"
		}
	end	
  
end