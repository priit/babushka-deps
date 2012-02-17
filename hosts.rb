dep 'hosts.no_sendmail' do
  met? { !grep(/^sendmail: all/, '/etc/hosts.allow') }
  meet do 
    change_line 'sendmail: all', '# sendmail: all', '/etc/hosts.allow'
  end
end

dep 'hosts.deny' do
  met? do
    if grep(/^ALL: ALL/, '/etc/hosts.deny') 
      true
    else
      confirm('Should we add "ALL: ALL" to /etc/hosts.deny')
    end
  end

  meet do 
    append_to_file "ALL: ALL", "/etc/hosts.deny" 
  end
end

dep 'hosts.allow', :allowed_ips do
  allowed_ips.ask('Allowed ips (separated by comma)')

  met? do
    return true if grep(/^ALL: /, '/etc/hosts.allow') 
    #if grep(/^ALL: /, '/etc/hosts.allow') 
      #true
    #else
      #confirm('Should we add ALL: localhost + ips to /etc/hosts.allow?')
    #end
  end

  meet do 
    append_to_file "ALL: localhost, #{allowed_ips}", "/etc/hosts.allow" 
  end
end

dep 'hosts.conf' do
  requires 'hosts.no_sendmail'
  requires 'hosts.allow'
  requires 'hosts.deny'
end
