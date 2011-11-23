dep 'user', :username do
  requires 'zsh'

  met? { grep(/^#{username}:/, '/etc/passwd') }
  meet {
    sudo "mkdir -p /home/#{username}" and
    sudo "useradd -m -s /bin/zsh -b /home -G admin #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo "passwd #{username"
  }
end
