dep 'basic', :username do
  username.ask("Additional user along root user:").default(shell('whoami'))

  requires 'locales.conf'
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'

  requires 'zsh.conf'.with(username) if username != 'root'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'root'
  requires 'vim.confroot'
end

deb 'tree.managed' 
deb 'unzip.managed'
deb 'zip.managed'
