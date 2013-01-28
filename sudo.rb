dep 'sudo', :username do
  met? { '/etc/sudoers'.p.grep(/^#{username}/) }
  meet do 
    '/etc/sudoers'.p.append("#{username} ALL=(ALL:ALL) ALL, NOPASSWD:/etc/init.d/apache2, /etc/init.d/nginx") 
  end
end
