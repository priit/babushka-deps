dep 'group', :name do
  met? { grep(/^#{name}:/, '/etc/group') }
  meet { sudo "groupadd #{name}" }
end

dep 'user', :username, :password do
  requires 'zsh'
  requires 'group'.with(username)
  password.ask("Additional user password")

  met? { grep(/^#{username}:/, '/etc/passwd') }
  meet {
    sudo "mkdir -p /home/#{username}" and
    sudo "useradd -m -s /bin/zsh -b /home -G #{username} #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end
