dep 'vim.managed'

dep 'vim.conf', :username  do
  requires 'vim.managed'
  username.default!(shell('whoami'))

  met? { username == 'root' ? true : "/home/#{username}/.vimrc".p.exists? }
  meet do
    render_erb 'dotfiles/vimrc', :to => "/home/#{username}/.vimrc".p
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.vimrc"
  end
end

dep 'vim.confroot' do
  requires 'vim.managed'

  met? { "/root/.vimrc".p.exists? }
  meet do
    render_erb 'dotfiles/vimrc', :to => "/root/.vimrc".p
  end
end
