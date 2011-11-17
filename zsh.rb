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

  met? { '~/.zshrc'.p.exists? }
  meet { render_erb 'dotfiles/zshrc', :to => '~/.zshrc'.p }
end
