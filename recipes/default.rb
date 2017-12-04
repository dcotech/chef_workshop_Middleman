#
# Cookbook:: middleman
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#


#########################
### Prerequiste packages
#########################
package %w(build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3

           curl
           git-core
           nodejs
           git
           wget
           apache2) do 
end

  
#user 'thin_user' do
 # comment 'Thin user to configure thin service and install the bundler'
 # uid '2001'
 # home '/home/thin_user'
 # shell '/bin/bash'
#end



###################
### Apache resources
####################

service node['apache_service'] do
  action :start 
  subscribes :restart, 'cookbook_file[/etc/apache2/sites-enabled/blog.conf]', :immediately
end



##################################################################
#### Installation of Ruby and configuration of apache module
###################################################################

remote_file '/tmp/ruby-2.1.1' do
   source 'http://cache.ruby-lang.org/pub/ruby/ruby-2.1.3.tar.gz'
   owner 'root'
   group 'root'
   mode '0755'
end

bash 'install ruby' do
#  user 'root'
  code <<-EOH
    mkdir ~/

    cd ~/ruby

    wget http://cache.ruby-lang.org/pub/ruby/ruby-2.1.3.tar.gz

    tar -xzf ruby-2.1.3.tar.gz

    cd ruby-2.1.3

    sudo ./configure

    sudo make install

    sudo rm -rf ~/ruby
  EOH
  not_if { ::File.exist?('/usr/local/include/ruby-2.1.0/x86_64-linux/ruby' )}
end

bash 'enable proper apache modules' do
  code <<-EOH
    sudo a2enmod proxy_http

    sudo a2enmod rewrite

    sudo rm /etc/apache2/sites-enabled/000-default.conf
   EOH
  ignore_failure true
end

template '/etc/apache2/sites-enabled/blog.conf' do
   source 'blog.conf.erb'
   owner 'www-data'
   group 'www-data'
   mode '0755'
   variables ({
    ipaddress: node['ipaddress']
   })
end



####################################################################
#### Cloning Git middleman repo, installing bundler, and thin service
#####################################################################


bash 'Cloning git repo and installing prequisite services' do
   code <<-EOH
    cd

    git clone https://github.com/learnchef/middleman-blog.git

    cd middleman-blog/

    sudo gem install bundler
      
    bundle install
      
    sudo thin install
 
    sudo /usr/sbin/update-rc.d -f thin defaults
  EOH
end


template '/etc/init.d/thin' do
  source 'thin.erb'
  owner 'root'
  group 'root'
  mode '0755'
  #variables ({
   #project_install_directory: node['project_install_directory']
# })
end

template '/etc/thin/blog.yml' do
  source 'blog.yml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  #variabes ({
 # project_install_directory: node['project_install_directory']
 # })
end


service 'thin' do 
  action :restart
end


