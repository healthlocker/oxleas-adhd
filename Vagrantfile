# -*- mode: ruby -*-
# vi: set ft=ruby :

# detailed instructions for installing
$script = <<SCRIPT

sudo -i
# update ubuntu (security etc.)
apt-get update

# curl
apt-get install curl -y

# nodejs
apt-get -y install g++ git git-core nodejs npm
#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash && source .bashrc
#nvm install node
#node -v

# PostgreSQL
apt-get install postgresql postgresql-contrib -y
#sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
# Confirm Postgres is running:
/etc/init.d/postgresql status

# erlang
# apt-get install erlang -y

# elixir
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install esl-erlang -y
apt-get install elixir -y

# install erlang-odbc
# apt-get install erlang-odbc -y

# hex
mix local.hex --force

# phoenix
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

#apt-get install inotify-tools -y

#curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
#apt-get update
#ACCEPT_EULA=Y apt-get install msodbcsql -y
#apt-get install unixodbc-utf16 unixodbc-dev-utf16 -y
## # optional: for bcp and sqlcmd
#ACCEPT_EULA=Y apt-get install mssql-tools -y
## Add tools to path
#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#source ~/.bashrc
## optional: for unixODBC development headers
#apt-get install unixodbc-dev -y

cd /home/ubuntu/oxleas


mix local.rebar --force
mix deps.clean --all
mix deps.get --force
mix deps.compile
#mix ecto.create -r Healthlocker.Repo
#mix ecto.migrate -r Healthlocker.Repo
#mix run priv/repo/seeds.exs
#mix phoenix.server

#mix edeliver build release

SCRIPT


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false
  config.vm.box_check_update = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 4000, host: 4000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "file", source: ".", destination: "oxleas"
  config.vm.provision :shell, :inline => $script
end
