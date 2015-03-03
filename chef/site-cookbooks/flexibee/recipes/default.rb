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

apt_repository 'download.flexibee.eu' do
  uri 'http://download.flexibee.eu/download/deb-repository/'
  distribution "flexibee"
  components ['non-free']
  keyserver    'keyserver.ubuntu.com'
  key          '70E18E2B'
  action :add
end

cookbook_file "/tmp/flexibee.seed" do
  source "flexibee.seed"
end

execute "preseed flexibee" do
  command "debconf-set-selections /tmp/flexibee.seed"
  action :run
end

apt_package "flexibee" do
  action :install
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