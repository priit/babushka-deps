dep 'sudo', :username do
  met? { grep(/^#{username}/, '/etc/sudoers') }
  meet do 
    append_to_file "#{username} ALL=(ALL:ALL) ALL, NOPASSWD:/etc/init.d/apache2", "/etc/sudoers" 
  end
end
