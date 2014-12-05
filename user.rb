# generic user for application deployment
dep 'create app user', :user, :password do
  user.ask("New app username'")
  password.ask("User #{user} password for sudo")

  requires 'zsh'
  # requires 'create user'.with(user, password)
  # requires 'user is sudoer'.with(user)
end

# basic user
dep 'create user', :user, :password do
  requires 'zsh'
  requires 'create group'.with(user)

  met? { '/etc/passwd'.p.grep(/^#{user}:/) }
  meet {
    sudo "useradd --create-home --shell /bin/zsh --base-dir /home --groups #{user}" and
    sudo "chmod 701 /home/#{user}" and
    sudo "chown #{user}:#{user} -R /home/#{user}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{user}}
  }
end

dep 'create group', :group do
  met? { '/etc/group'.p.grep(/^#{group}:/) }
  meet { sudo "groupadd #{group}" }
end
