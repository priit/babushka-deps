dep 'basic', :username do
  username.default!(shell('whoami'))

  requires 'zsh'
  requires 'zsh'.with(username)
end
