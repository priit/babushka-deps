dep 'screen.managed'

dep 'screen.conf', :username  do
  username.default!(shell('whoami'))

  before { shell "touch /home/#{username}/.screenrc" }
  met? { username == 'root' ? true : "/home/#{username}/.screenrc".p.grep(/^vbell on/, "/home/#{username}/.screenrc") }
  meet do
    "/home/#{username}/.screenrc".p.append('vbell off')
    "/home/#{username}/.screenrc".p.append('startup_message off')
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.screenrc"
  end
end

dep 'screen.turn_off_startup_message' do
  met? { '/etc/screenrc'.p.grep(/^startup_message on/) }
  meet do
    '/etc/screenrc'.p.append("\n# Added by Babushka\n")
    '/etc/screenrc'.p.append("startup_message off\n")
  end
end

dep 'screen.confroot' do
  before { shell "touch /root/.screenrc" }
  met? { '/root/.screenrc'.p.grep(/^vbell on/) }
  meet do
    '/root/.screenrc'.p.append('vbell off')
  end
end

