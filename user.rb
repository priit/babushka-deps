dep 'group', :groupname do
  met? { grep(/^#{groupname}:/, '/etc/group') }
  meet { sudo "groupadd #{groupname}" }
end

dep 'user', :username, :password do
  requires 'zsh'
  requires 'group'.with(username)
  password.ask("Additional user password")

  met? { grep(/^#{username}:/, '/etc/passwd') }
  meet {
    sudo "mkdir -p /home/#{username}" and
    sudo "useradd -m -s /bin/zsh -b /home -g #{username} #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end
