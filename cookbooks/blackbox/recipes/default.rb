remote_file '/data/blackbox/shared/config/config.json' do
  source 'config.json'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
