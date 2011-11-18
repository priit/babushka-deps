dep 'basic', :username do
  username.ask("Additional user along root user:").default(shell('whoami'))

  requires 'locales.conf'
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'

  requires 'screen.conf'.with(username) if username != 'root'
  requires 'screen.confroot'

  requires 'zsh.conf'.with(username) if username != 'root'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'root'
  requires 'vim.confroot'
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'
