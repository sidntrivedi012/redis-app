# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.synced_folder ".", "/etc/demo-ops", type: "rsync",
    rsync__exclude: ".git/"

  # Enable provisioning with a ansible.
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/playbook.yml"
  end
end
