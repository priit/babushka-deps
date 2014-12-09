dep 'vim.managed'

dep 'vimrc_priit' do
  requires 'vim.managed'

  met? { "/opt/vimrc-priit".p.exists? }
  meet do
    render_erb 'vim/vimrc-priit', :to => "/opt/vimrc-priit".p, :comment => '"'
  end
end
