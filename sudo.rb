dep 'sudoers.d' do
  met? { grep(/^includedir \/etc\/sudoers.d/, '/etc/sudoers') }
  meet { append_to_file 'includedir /etc/sudoers.d', '/etc/sudoers' }
end

dep 'sudo', :username do
  requires 'sudoers.d'

  met? { "/etc/sudoers.d/#{username}".p.exists? }
  meet do 
    sudo "rm /etc/sudoers.d/#{username}"
    sudo "touch /etc/sudoers.d/#{username}"
    append_to_file "#{username} ALL=(ALL:ALL) ALL", "/etc/sudoers.d/#{username}" 
    sudo "chmod 0440 /etc/sudoers.d/#{username}"
  end
end
