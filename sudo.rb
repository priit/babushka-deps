dep 'sudo', :username do
  met? { grep(/^#{username}/, '/etc/sudoers') }
  meet do 
    append_to_file "#{username} ALL=(ALL:ALL) ALL", "/etc/sudoers" 
  end
end

dep 'sudo.apache_no_password', :username do
  require 'sudo'.with(:username)

  met? { grep(/^#{username}/, '/etc/sudoers') }
  meet do 
    change_line "#{username} ALL=(ALL:ALL) ALL", 
      "#{username} ALL=(ALL:ALL) ALL, NOPASSWD:/etc/init.d/apache2", 
      "/etc/sudoers" 
  end
end
