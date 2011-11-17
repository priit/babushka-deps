dep 'basic', :username do
  username.ask("Additional user along root user:").default(shell('whoami'))

  requires 'zsh.conf'.with(username) if username != 'root'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'root'
  requires 'vim.confroot'
end
