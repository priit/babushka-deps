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
