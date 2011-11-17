dep 'basic', :username do
  username.default!(shell('whoami'))

  requires 'zsh.conf' # for root user
  requires 'zsh.conf'.with(username)
end
