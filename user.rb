dep 'user', :username do
  requires 'zsh'
  password.ask("Additional user password: ")

  met? { grep(/^#{username}:/, '/etc/passwd') }
  meet {
    sudo "mkdir -p /home/#{username}" and
    sudo "useradd -m -s /bin/zsh -b /home -G admin #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end
