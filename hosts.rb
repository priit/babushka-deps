dep 'hosts.no_sendmail' do
  met? { !grep(/^sendmail: all/, '/etc/hosts.allow') }
  meet do 
    change_line 'sendmail: all', '# sendmail: all', '/etc/hosts.allow'
  end
end

dep 'hosts.deny' do
  met? { grep(/^ALL: ALL/, '/etc/hosts.deny') }
  meet do 
    append_to_file "ALL: ALL", "/etc/hosts.deny" 
  end
end

dep 'hosts.allow', :allowed_ips do
  allowed_ips.ask('Please give list of allowed ips (separated by comma)')

  met? { grep(/^ALL: /, '/etc/hosts.allow') }
  meet do 
    append_to_file "ALL: localhost, #{allowed_ips}", "/etc/hosts.allow" 
  end
end

dep 'hosts.conf' do
  requires 'hosts.no_sendmail'
  requires 'hosts.allow'
  requires 'hosts.deny'
end
