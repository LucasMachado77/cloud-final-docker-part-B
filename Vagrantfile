# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Script para instalar o Docker em todas as VMs
  $docker_install_script = <<-SHELL
    echo "---- Instalando Docker e Git ----"
    apt-get update -y
    apt-get install -y ca-certificates curl git
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
    usermod -aG docker vagrant
    echo "---- Instalação do Docker concluída! ----"
  SHELL

  # Define a box base para todas as VMs
  config.vm.box = "bento/ubuntu-22.04"

  # Garante que a pasta atual (com o código fonte) está disponível em /vagrant
  config.vm.synced_folder ".", "/vagrant", disabled: false

  # --- Configuração do Nó Manager ---
  config.vm.define "manager" do |node|
    node.vm.hostname = "manager"
    node.vm.network :private_network, ip: "192.168.56.10"
    node.vm.provision "shell", inline: $docker_install_script
  end

  # --- Configuração dos Nós Worker ---
  (1..2).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.hostname = "worker-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{10 + i}"
      node.vm.provision "shell", inline: $docker_install_script
    end
  end
end