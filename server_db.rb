# 
# DB basic template
#
dep 'server_db' do
  require 'ostruct'
  require 'yaml'
  conf = OpenStruct.new(YAML.load_file('babushka.yml')['server_db'])

  requires 'general'
  requires 'user'.with(conf.username)
  requires 'debian_custom'
  requires 'network_ip_failover'
end
