dep 'sudo', :username do
  met? { '/etc/sudoers'.p.grep(/^#{username}/) }
  meet do 
    append_to_file "#{username} ALL=(ALL:ALL) ALL, NOPASSWD:/etc/init.d/apache2", "/etc/sudoers" 
  end
end
