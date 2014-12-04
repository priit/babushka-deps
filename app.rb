dep 'app', :username, :password do
  username.ask("Short app name for creating same linux user:").default('skip')
  password.ask("Adding password").default('skip')

  requires 'sudo.bin'
  requires 'user'.with(username, password) if username != 'skip' && password != 'skip'
  requires 'sudo'.with(username) if username != 'skip'
  requires 'locales.conf'

  requires 'hosts.conf'

  requires 'zsh.conf'.with(username) if username != 'skip'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'skip'
  requires 'vim.confroot'

  requires 'ssh.authorized_keys'.with(username, nil) if username != 'skip'

  requires 'ssh.conf'.with(username)
end
