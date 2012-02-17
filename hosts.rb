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

  met? do
    if grep(/^ALL: /, '/etc/hosts.allow') 
      true
    else
      if confirm('Should we turn on whitelist and alter hotst.allow/deny files?') == 'y'
        allowed_ips.ask('Please give list of allowed ips (separated by comma)')
      else 
        true
      end
    end
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
