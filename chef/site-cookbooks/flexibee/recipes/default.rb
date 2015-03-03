#
# Cookbook Name:: flexibee
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'locales::install'
include_recipe 'locale-gen'
include_recipe 'locale'
include_recipe 'postgresql::server'
include_recipe "java"

packages=%w{ postgresql-client-common postgresql-common postgresql postgresql-pltcl postgresql-contrib }
packages.each do |pkg|
  package pkg do
    action [:upgrade]
  end
end

cookbook_file "/tmp/flexibee_2014.4.6_all.deb" do 
  source "flexibee_2014.4.6_all.deb"
  mode 0644
end

#remote_file "/tmp/flexibee_2014.4.6_all.deb" do	
#  source "http://download.flexibee.eu/download/2014.4/2014.4.6/flexibee_2014.4.6_all.deb"
#  mode 0644
#end

cookbook_file "/tmp/flexibee.seed" do
  source "flexibee.seed"
end

execute "preseed flexibee" do
  command "debconf-set-selections /tmp/flexibee.seed"
  action :run
end

dpkg_package "flexibee" do
  source "/tmp/flexibee_2014.4.6_all.deb"
  action [:install]
end

# distribute settings for request authentification
# see http://www.flexibee.eu/api/doc/ref/batch-api
template "/etc/flexibee/server-auth.xml" do
  source "server-auth.xml.erb"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/etc/postgresql/9.1/flexibee/pg_hba.conf" do
  action :create
  source "pg_hba.conf"
  mode 0644
  owner "postgres"
  group "root"
  notifies :restart, "service[postgresql]", :delayed
end

template "/etc/flexibee/flexibee-server.xml" do
  source "flexibee-server.xml.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[flexibee]", :delayed
end

cookbook_file "/etc/default/flexibee" do
  action :create
  source "flexibeeDefaults"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[flexibee]", :delayed
end

cookbook_file "/etc/postgresql/9.1/flexibee/postgresql.conf" do
  action :create
  source "postgresql.conf"
  mode 0644
  owner "postgres"
  group "root"
  notifies :restart, "service[postgresql]", :delayed
end

service "postgresql" do
  supports :restart => true, :reload => true
  provider Chef::Provider::Service::Init::Debian
  action :nothing
end

service "flexibee" do
  supports :restart => true, :reload => true
  provider Chef::Provider::Service::Init::Debian
  action :nothing
end