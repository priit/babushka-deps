dep 'zsh', :username do
  requires 'zsh.managed'
  username.default!(shell('whoami'))
  met? { shell("sudo su - '#{username}' -c 'echo $SHELL'") == which('zsh') }
  meet { sudo("chsh -s '#{which('zsh')}' #{username}") }
end
