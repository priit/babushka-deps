# only very general basic stuff, 
# should be harmless in most situations
dep 'general' do
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'
  requires 'screen.managed'
  requires 'screen.turn_off_startup_message'
  requires 'screen.turn_off_vbell'
  requires 'htop.managed'
  requires 'cron.default_email'
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'
dep 'htop.managed'

dep 'build-essential' do
  met? { shell('dpkg -l | grep "build-essential"') }
  meet { sudo 'apt-get install build-essential -y' }
end

#
# Screen
#
dep 'screen.managed'

dep 'screen.turn_off_startup_message' do
  met? { '/etc/screenrc'.p.grep(/^startup_message off/) }
  meet do
    '/etc/screenrc'.p.append("\n# Added by Babushka\n")
    '/etc/screenrc'.p.append("startup_message off\n")
  end
end

dep 'screen.turn_off_vbell' do
  met? { '/etc/screenrc'.p.grep(/^vbell off/) }
  meet do
    '/etc/screenrc'.p.append("\n# Added by Babushka\n")
    '/etc/screenrc'.p.append("vbell off\n")
  end
end

#
# Cron default email
#
dep 'cron.default_email' do
  met? { '/etc/default/cron'.p.grep(/^MAILTO=info@gitlab/) }
  meet do
    '/etc/default/cron'.p.append("\n# Added by Babushka\n")
    '/etc/default/cron'.p.append("MAILTO=info@gitlab.eu\n")
  end
end
