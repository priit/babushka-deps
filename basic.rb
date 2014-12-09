# only very basic stuff
dep 'basic' do
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'
  requires 'screen.managed'
  requires 'screen.turn_off_startup_message'
  requires 'screen.turn_off_vbell'
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'


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
