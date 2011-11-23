dep 'sudoers.d' do
  met? { grep(/^includedir \/etc\/sudoers.d/, '/etc/sudoers') }
  meet { sudo "echo 'includedir /etc/sudoers.d' >> /etc/sudoers" }
end

dep 'sudo', :username do
  requires 'sudoers.d'

  met? { "/etc/sudoers.d/#{username}".p.exists? }
  meet { sudo "echo '#{username} ALL=(ALL:ALL) ALL' > /etc/sudoers.d/#{username}" }
end
