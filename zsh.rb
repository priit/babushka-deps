dep 'zsh.managed'

dep 'zsh', :user do
  requires 'zsh.managed'
  user.default!(shell('whoami'))

  met? { shell("sudo su - '#{user}' -c 'echo $SHELL'") == which('zsh') }
  meet { sudo("chsh -s '#{which('zsh')}' #{user}") }
end

dep 'user zshrc file', :user do
  requires 'zsh'.with(user)

  met? { user == 'root' ? true : "/home/#{user}/.zshrc".p.exists? }
  meet do
    render_erb 'zsh/zshrc', :to => "/home/#{user}/.zshrc".p
    log_shell  "Set owner as #{user}:#{user}:", 
      "chown #{user}:#{user} /home/#{user}/.zshrc"
  end
end

# root
dep 'root zshrc file' do
  requires 'zsh'.with('root')
  met? { "/root/.zshrc".p.exists? }
  meet { render_erb 'zsh/zshrc', :to => "/root/.zshrc".p }
end
