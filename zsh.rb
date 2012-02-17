dep 'zsh.managed'

dep 'zsh', :username do
  requires 'zsh.managed'
  username.default!(shell('whoami'))
  met? { shell("sudo su - '#{username}' -c 'echo $SHELL'") == which('zsh') }
  meet { sudo("chsh -s '#{which('zsh')}' #{username}") }
end

dep 'zsh.conf', :username do
  username.default!(shell('whoami'))
  requires 'zsh'.with(username)

  met? { username == 'root' ? true : "/home/#{username}/.zshrc".p.exists? }
  meet do
    render_erb 'zsh/zshrc', :to => "/home/#{username}/.zshrc".p
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.zshrc"
  end
end

# root
dep 'zsh.confroot' do
  requires 'zsh'.with('root')
  met? { "/root/.zshrc".p.exists? }
  meet { render_erb 'zsh/zshrc', :to => "/root/.zshrc".p }
end
