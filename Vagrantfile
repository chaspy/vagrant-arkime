VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.define :arkime do | arkime |
    arkime.vm.hostname = "arkime"
    arkime.vm.network :private_network, ip: "192.168.33.100"#, virtualbox__intnet: "intnet"
    arkime.vm.provision :shell, :path => "./init.sh",:privileged   => true
  end
end
