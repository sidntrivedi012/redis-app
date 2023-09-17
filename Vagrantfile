# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  # Enable provisioning with a ansible.
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
  end
end
