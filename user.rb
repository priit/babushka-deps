# generic user for application deployment
dep 'app_user', :username, :password do
  username.ask("New app username'")
  password.ask("New password")

  requires 'user'.with(username, password)
  requires 'ssh_all_authorized_keys'.with(username)
  requires 'zshrc'.with(username)
  requires 'sudoer'.with(username)
end

# basic user with zsh
dep 'user', :username, :password do
  requires 'zsh'
  requires 'group'.with(username)

  met? { '/etc/passwd'.p.grep(/^#{username}:/) }
  meet {
    sudo "useradd --create-home --shell /bin/zsh --base-dir /home -g #{username} #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo "chown #{username}:#{username} -R /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end

dep 'group', :groupname do
  met? { '/etc/group'.p.grep(/^#{groupname}:/) }
  meet { sudo "groupadd #{groupname}" }
end

dep 'sudoer', :username do
  met? do
    path.p.exists?
  end 

  meet do 
    filename.p.write("#{username} ALL=(ALL:ALL) ALL") 
    if shell "visudo -cf #{filename}"
      shell "mv #{filename} #{path}"
    else
      puts 'Syntax error in new sudoers file'
    end
  end

  def path
    "/etc/sudoers.d/#{filename}"
  end

  def filename
    "user-#{username}"
  end
end

