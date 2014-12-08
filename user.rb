# generic user for application deployment
dep 'new_app_user', :user, :password do
  username.ask("Additional user along root user:").default('skip')
  password.ask("Additional user password").default('skip')
  user.ask("New app username'").default('aaaa')
  password.ask("New user password for sudo")

  # requires 'zsh'
  # requires 'create user'.with(user, password)
  # requires 'user is sudoer'.with(user)
  met? { 
    user.ask("eeeNew app username'").default('aaaa')
  }
  meet { 
    user.ask("ieeNew app username'").default('aaaa')
  }
end

# basic user
dep 'new_user', :user, :password do
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

dep 'new_group', :group do
  met? { '/etc/group'.p.grep(/^#{group}:/) }
  meet { sudo "groupadd #{group}" }
end
