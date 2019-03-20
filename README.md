
# LAMP Stacks Made Easy with Vagrant

## Prerequisites
* [Vagrant](http://www.vagrantup.com/)
* [Virtual Box](https://www.virtualbox.org/)

> **Important:** All the commands below needs to be run from within the git repository root folder where the `Vagrantfile` is located otherwise you will end up with noise messages saying no Vagrant machine has been found!!

## Instructions
1. Ensure Vagrant and Virtual Box are installed (preferred latest version of each but is up to you)
2. Open the `Vagrantfile` file and remove the comment from the following line:
```bash
#Before
#config.vm.provision :shell, :path => "bootstrap.sh"

#After
config.vm.provision :shell, :path => "bootstrap.sh"
```
3. Save your changes and start the vagrant box and wait until the process finish:
```bash
$ vagrant up
```
That's it by now you should have a LAMP environment up and running with a few commands.
## Customize your LAMP box by adding databases and setting up Virtual Hosts
1. If your virtual machine is running then stop it using the following command:
```bash
$ vagrant halt
```
2. If you want to import databases (SQL files) place them inside the `files/db` directory.
3. Open the `files\vhosts.conf` file and add your Virtual Host sections there.  For example:
```
<VirtualHost *:80>
    DocumentRoot "/var/www/html/<project_name>"
    ServerName <preferred_name>
    ServerAlias [preferred_alias] # this section is optional

    <Directory "/var/www/html/<project_name>">
        DirectoryIndex index.php
        AllowOverride all
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
```
4. Open the `Vagrantfile` file and make the following changes:
```bash
#Before
config.vm.provision :shell, :path => "bootstrap.sh"
#config.vm.provision :shell, :path => "common.sh"

#After
#config.vm.provision :shell, :path => "bootstrap.sh"
config.vm.provision :shell, :path => "common.sh"
```
5. Save your changes, start the vagrant box and wait until the process finish:
```bash
$ vagrant up
```
You're all set up. The webserver will now be accessible from http://<preferred_name> or any other Virtual Host name that you have defined previously.
## Communicating with the host
Sometimes we might need that our application establish a communication with an application and/or service running in the host. Because the guest does not know anything about the host so we have to tell it about it's existence. One example can be SQL Server that runs on the host while the application does run on the guest.

We achieve this by installing a [plugin](https://github.com/oscar-stack/vagrant-hosts) and adding a few changes to our `Vagrantfile`.

1.  Install the plugin:
```bash
$ vagrant plugin install vagrant-hosts
```
2. Add the following section to your `Vagrantfile`:
```bash
config.vm.provision :hosts do |provisioner|
	provisioner.add_host '192.168.56.1', [
		'SOMENAME',
		'SOMEOTHERNAME'
	]
end
```
In the above lines we are letting know the guest about the existence of `SOMENAME` and `SOMEOTHERNAME` in the host IP address. The entries will be added automatically to the file `/etc/hosts` in the guest operating system.
## System Package include
* apache2 - rewrite mode enabled, having virtual host with config
* php5
* php5-cli
* php5-mysql
* php5-gd
* php5-mcrypt
* libapache2-mod-php5
* MySQL 5.7
* curl
* nano
* htop
* xdebug
