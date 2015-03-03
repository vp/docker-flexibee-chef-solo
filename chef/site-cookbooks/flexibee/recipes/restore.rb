#
# Cookbook Name:: flexibee
# Recipe:: restore
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# TODO: DOES NOT WORK

http_request "restore flexibee company" do
  action :put
  url "http://localhost:5434/c/" + node['eset']['flexibee']['company'] + "/restore"
  message (File.read( node['eset']['flexibee']['backup_file']))
  headers({"AUTHORIZATION" => "Basic #{Base64.encode64(node['eset']['flexibee']['user']+":"+node['eset']['flexibee']['password'])}","Content-Type" => "application/data"})
end