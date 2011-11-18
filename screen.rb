dep 'screen.managed'

dep 'screen.conf', :username  do
  username.default!(shell('whoami'))

  before { shell "touch /home/#{username}/.screenrc" }
  met? { usernaem == 'root' ? true : grep(/^vbell on/, "/home/#{username}/.screenrc") }
  meet do
    append_to_file 'vbell on', "/home/#{username}/.screenrc"
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.screenrc"
  end
end

dep 'screen.confroot' do
  before { shell "touch /root/.screenrc" }
  met? { grep(/^vbell on/, "/root/.screenrc") }
  meet do
    append_to_file 'vbell on', "/root/.screenrc"
  end
end

