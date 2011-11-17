dep 'basic', :username do
  username.default!(shell('whoami'))

  requires 'zsh' # for root user
  requires 'zsh'.with(username)
end
