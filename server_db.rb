# 
# DB basic template
#
dep 'server_db', :password do
  require 'ostruct'
  require 'yaml'
  conf_file = 'babushka.yml'

  if conf_file.p.exists?
    conf = OpenStruct.new(YAML.load_file(conf_file)['server_db'])
    password.ask("New password")

    requires 'general'
    requires 'user'.with(conf.user, password, conf.authorized_keys)
    requires 'debian_custom'
    requires 'network_ip_failover'
  else
    requires 'server_db_yml'
    puts "/n/nPlease edit babushka.yml file before continue/n"
  end
end

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
