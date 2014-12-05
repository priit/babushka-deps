dep 'user', :username, :password do
  requires 'zsh'
  requires 'group'.with(username)
  password.ask("Enter user root password")

  met? { '/etc/passwd'.p.grep(/^#{username}:/) }
  meet {
    sudo "useradd --create-home --shell /bin/zsh --base-dir /home --groups #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo "chown #{username}:#{username} -R /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end

dep 'group', :groupname do
  met? { '/etc/group'.p.grep(/^#{groupname}:/) }
  meet { sudo "groupadd #{groupname}" }
end
