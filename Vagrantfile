# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "centos-5.7-x86_64"
  config.vm.box_url = "http://dl.dropbox.com/u/8417998/centos-5.7-1.8.7-chef.box"
  config.vm.network :hostonly, "192.168.50.4", :netmask => "255.255.0.0"
  config.vm.network :hostonly, "33.33.33.2"
  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "cookbooks"
     chef.add_recipe "minitest-test-cookbook"
     chef.add_recipe "minitest-handle-cookbook"
  end
end
