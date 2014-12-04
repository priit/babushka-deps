dep 'hosts.no_sendmail' do
  met? { !'/etc/hosts.allow'.p.grep(/^sendmail: all/) }
  meet do 
    change_line 'sendmail: all', '# sendmail: all', '/etc/hosts.allow'
  end
end

dep 'hosts.deny' do
  met? do
    if '/etc/hosts.deny'.p.grep(/^ALL: ALL/) 
      true
    else
      !confirm('Should we add "ALL: ALL" to /etc/hosts.deny')
    end
  end

  meet do 
    '/etc/hosts.deny'.p.append("ALL: ALL")
  end
end

dep 'hosts.allow', :allowed_ips do

  met? do
    if '/etc/hosts.allow'.p.grep(/^ALL: /) 
      true
    else
      if confirm('Should we add ALL: localhost + ips to /etc/hosts.allow?')
        allowed_ips.ask('Allowed ips (separated by comma)')
        false
      else
        true
      end
    end
  end

  meet do 
    '/etc/hosts.allow'.p.append("ALL: localhost, #{allowed_ips}") 
  end
end

dep 'hosts.conf' do
  requires 'hosts.no_sendmail'
  requires 'hosts.allow'
  requires 'hosts.deny'
end
