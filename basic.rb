dep 'basic', :username, :password do
  username.ask("Additional user along root user:").default(shell('whoami'))
  password.ask("Additional user password")

  requires 'apt'
  requires 'sudo.managed'
  requires 'env'
  requires 'user'.with(username, password) if username != 'root'
  requires 'sudo'.with(username) if username != 'root'
  requires 'locales.conf'
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'

  requires 'hosts.conf'

  requires 'screen.conf'.with(username) if username != 'root'
  requires 'screen.confroot'

  requires 'zsh.conf'.with(username) if username != 'root'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'root'
  requires 'vim.confroot'

  if username != 'root'
    requires 'ssh.authorized_keys'.with(username, nil)
    requires 'ssh.authorized_keys-twice'.with(username, nil)
  end

  requires 'ssh.conf'.with(username)
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'
