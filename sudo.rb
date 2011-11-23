dep 'sudo', :username do
  met? { grep(/^#{username}/, '/etc/sudoers') }
  meet do 
    append_to_file "#{username} ALL=(ALL:ALL) ALL", "/etc/sudoers" 
  end
end
