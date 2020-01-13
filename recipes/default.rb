#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe "nodejs"
include_recipe "apt"
package "nginx"
service 'nginx' do
  supports status:  true, restart: true, reload: true
  action [:enable, :start]
end
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end
link '/etc/nginx/sites-enabled/default' do
  notifies :restart, 'service[nginx]'
  action :delete
end

apt_update 'updated_sources' do
  action :update
end

nodejs_npm 'pm2' do
  action :install
end
