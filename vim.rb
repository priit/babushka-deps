dep 'vim.managed'

dep 'vimrc_priit' do
  requires 'vim.managed'

  met? { "/etc/vim/vimrc-priit".p.exists? }
  meet do
    render_erb 'vim/vimrc-priit', :to => "/etc/vim/vimrc-priit".p, :comment => '"'
  end
end
