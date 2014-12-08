# generic user for application deployment
dep 'app_user', :name, :password do
  name.ask("New app username'")
  password.ask("New password")

  requires 'new_user'.with(name, password)
  # requires 'user is sudoer'.with(name)
  met? { 
  }
  meet { 
  }
end

# basic user with zsh
dep 'user', :name, :password do
  requires 'zsh'
  requires 'new_group'.with(name)

  met? { '/etc/passwd'.p.grep(/^#{name}:/) }
  meet {
    sudo "useradd --create-home --shell /bin/zsh --base-dir /home --groups #{name} #{name}" and
    sudo "chmod 701 /home/#{name}" and
    sudo "chown #{name}:#{name} -R /home/#{name}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{name}}
  }
end

dep 'group', :name do
  met? { '/etc/group'.p.grep(/^#{name}:/) }
  meet { sudo "groupadd #{name}" }
end
