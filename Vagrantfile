Vagrant::Config.run do |config|
  config.ssh.timeout = 15
  config.vm.box = "centos-6.2-x86_64-chef"
#  config.vm.box_url = "http://dl.dropbox.com/u/8417998/centos-5.7-1.8.7-chef.box"
  config.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  config.vm.provision :shell, :inline => "grep '8.8.8.8' /etc/resolv.conf || echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
  config.vm.provision :shell, :inline => "$(selinuxenabled && setenforce 0) || exit 0"
  config.vm.provision :shell, :inline => 'echo "UseDNS no" >> /etc/ssh/sshd_config && service sshd reload'
  config.vm.provision :shell, :inline => 'iptables -F'
  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "cookbooks"
     chef.run_list = [
       "recipe[git]",
       "recipe[minitest-test-cookbook]",
       "recipe[minitest-handler-cookbook]"
     ]
  end
end

