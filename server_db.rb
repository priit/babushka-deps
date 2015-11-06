# 
# DB basic template
#
dep 'server_db', :password do
  require 'ostruct'
  require 'yaml'
  conf = OpenStruct.new(YAML.load_file('babushka.yml')['server_db'])
  password.ask("New password")

  requires 'general'
  requires 'user'.with(conf.user, password)
  requires 'debian_custom'
  requires 'network_ip_failover'
end
