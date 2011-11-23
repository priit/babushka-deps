dep 'sudoers' do
  met? { grep(/^includedir \/etc\/sudoers.d/, '/etc/sudoers') }
  meet { sudo "echo 'includedir /etc/sudoers.d' >> /etc/sudoers" }
end

dep 'sudo', :username do
  requires 'sudoers'

  met? { grep(/^#{username}:/, '/etc/sudoers') }
  meet {
    sudo "mkdir -p /home/#{username}" and
    sudo "useradd -m -s /bin/zsh -b /home -g #{username} #{username}" and
    sudo "chmod 701 /home/#{username}" and
    sudo "chown #{username}:#{username} -R /home/#{username}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{username}}
  }
end
