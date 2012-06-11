dep 'basic', :username, :password do
  username.ask("Additional user along root user:").default('skip')
  password.ask("Additional user password").default('skip')

  #requires 'apt'
  requires 'env'
  requires 'sudo.managed'
  requires 'user'.with(username, password) if username != 'skip' && password != 'skip'
  requires 'sudo'.with(username) if username != 'skip'
  requires 'locales.conf'
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'

  requires 'hosts.conf'

  requires 'screen.managed'
  requires 'screen.conf'.with(username) if username != 'skip'
  requires 'screen.confroot'

  requires 'zsh.conf'.with(username) if username != 'skip'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'skip'
  requires 'vim.confroot'

  if username != 'skip'
    requires 'ssh.authorized_keys'.with(username, nil)
    requires 'ssh.authorized_keys-twice'.with(username, nil)
  end

  requires 'ssh.conf'.with(username)
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'
