dep 'sudoer', :username do
  met? { '/etc/sudoers'.p.grep(/^#{username}/) }
  meet do 
    '/etc/sudoers'.p.append("#{username} ALL=(ALL:ALL) ALL") 
  end
end
