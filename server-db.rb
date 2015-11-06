# 
# DB basic template
#
dep 'server-db', :username, :password do
  username.ask("New app username'")
  password.ask("New password")

  requires 'general'
  requires 'user'.with(username, password)
  requires 'debian_custom'
end
