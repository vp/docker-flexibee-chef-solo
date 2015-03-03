#
# Cookbook Name:: Import flexibee admin user
# Recipe:: admin
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# TODO: DOES NOT WORK

# prepare user batch
template "/tmp/batch-admin.xml" do
  source "batch-admin.xml.erb"
  mode 0644
  owner "root"
  group "root"
end

execute "preseed flexibee" do
  command "curl 'https://localhost:5434/admin/batch' -k -T /tmp/batch-admin.xml"
  action :run
end