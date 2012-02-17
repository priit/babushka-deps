dep 'vim.managed'

dep 'vim.conf', :username  do
  requires 'vim.managed'
  username.default!(shell('whoami'))

  met? { username == 'root' ? true : "/home/#{username}/.vimrc-priit".p.exists? }
  meet do
    render_erb 'zsh/vimrc-priit', :to => "/home/#{username}/.vimrc-priit".p, :comment => '"'
    log_shell  "Set owner as #{username}:#{username}:", 
      "chown #{username}:#{username} /home/#{username}/.vimrc-priit"
  end
end

dep 'vim.confroot' do
  requires 'vim.managed'

  met? { "/root/.vimrc-priit".p.exists? }
  meet do
    render_erb 'zsh/vimrc-priit', :to => "/root/.vimrc-priit".p, :comment => '"'
  end
end
