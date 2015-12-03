#
# Cookbook Name:: sequelize_config
# Recipe:: default
#
# Generate the config/config.json needed by Sequelize

app_name = node[:applications].keys.first
env = node[:environment][:framework_env]

if ['solo', 'app_master', 'app'].include?(node[:instance_role])
  ey_cloud_report "Sequelize Config" do
    message "Sequelize Config - Loading database.yml for #{app_name} on #{env}"
  end
  
  dbconfig = YAML.load(File.read("/data/#{app_name}/shared/config/database.yml"))
  
  ey_cloud_report "Sequelize Config" do
    message "Sequelize Config - Generating config.json for #{app_name} on #{env}"
  end

  # create new config.json with attributes
  template "/data/#{app_name}/shared/config/config.json" do
    owner node[:owner_name]
    group node[:owner_name]
    backup false
    mode 0644
    source 'config.json.erb'
    variables({
      :environment => env,
      :adapter => dbconfig[env]["adapter"],
      :database => dbconfig[env]["database"],
      :username => dbconfig[env]["username"],
      :password => dbconfig[env]["password"],
      :host => dbconfig[env]["host"],
      :dialect => "postgres"
    })
  end
end
