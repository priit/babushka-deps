dep 'screen.managed'

dep 'screen.conf', :username  do
  username.default!(shell('whoami'))

  before { shell "touch /home/#{username}/.screenrc" }
  met? { username == 'root' ? true : grep(/^vbell on/, "/home/#{username}/.screenrc") }
  meet do
    append_to_file 'vbell off', "/home/#{username}/.screenrc"
    append_to_file 'startup_message off', "/home/#{username}/.screenrc"
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.screenrc"
  end
end

dep 'screen.confroot' do
  before { shell "touch /root/.screenrc" }
  met? { grep(/^vbell on/, "/root/.screenrc") }
  meet do
    append_to_file 'vbell off', "/root/.screenrc"
    append_to_file 'startup_message off', '/etc/screenrc'
  end
end

