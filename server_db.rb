# 
# DB basic template
#

# generate blank babushka yml file
dep 'server_db_yml' do
  met? do
    path.p.exists?
  end

  meet do 
    path.p.append <<-EOF.gsub(/^ {6}/, '')
      server_db:
        user: LINUX USERNAME
        authorized_keys: priit, martin
    EOF
  end
  
  def path
    'babushka.yml'
  end
end

dep 'server_db', :password do
  require 'ostruct'
  require 'yaml'
  conf = OpenStruct.new(YAML.load_file('babushka.yml')['server_db'])
  password.ask("New password")

  requires 'general'
  requires 'user'.with(conf.user, password, conf.authorized_keys)
  requires 'debian_custom'
  requires 'network_ip_failover'
end
