dep 'network_ip_failover', :ip_failover do
  met? do
    path.p.grep(/^# IP failover:/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    ip_failover.ask('Please provide failover ip:')
    net_dev = 'eth0'
    next_virtual_interface_nr = shell "grep -e 'iface[ \t]*#{net_dev}:' #{path} | wc --lines"
    vir_dev = "eth0:#{next_virtual_interface_nr}"
    
    conf =  
      "\n# IP failover:\n" \
      "auto #{vir_dev}\n" \
      "iface #{vir_dev} inet static\n" \
      "  address #{ip_failover}\n" \
      "  netmask 255.255.255.255\n\n" \
      "  post-up /sbin/ifconfig #{vir_dev} #{ip_failover} netmask 255.255.255.255 broadcast #{ip_failover}\n" \
      "  pre-down /sbin/ifconfig #{vir_dev} down\n"
    path.p.append(conf)
  end
  # after { shell '/etc/init.d/networking restart' }
  
  def path
    '/etc/network/interfaces'
  end
end
