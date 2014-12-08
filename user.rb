# generic user for application deployment
dep 'new_app_user', :user, :password do
  user.ask("New app username'")
  password.ask("New password")

  requires 'new_user'.with(user, password)
  # requires 'user is sudoer'.with(user)
  met? { 
  }
  meet { 
  }
end

# basic user with zsh
dep 'new_user', :user, :password do
  requires 'zsh'
  requires 'new_group'.with(user)

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
