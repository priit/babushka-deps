# 
# DB basic template
#
dep 'server_db', :username, :password do
  username.ask("New app username'")
  password.ask("New password")

  requires 'general'
  requires 'user'.with(username, password)
  requires 'debian_custom'
  requires 'network_ip_failover'
end
