dep 'vim.managed'

dep 'vimrc_priit' do
  requires 'vim.managed'
  requires 'v.bin'
  requires 'sshd_accept_vimuser_env'

  met? { "/etc/vim/vimrc-priit".p.exists? }
  meet do
    render_erb 'vim/vimrc-priit', :to => "/etc/vim/vimrc-priit".p, :comment => '"'
  end
end

dep 'v.bin' do
  met? { "/usr/bin/v".p.exists? }
  meet do
    render_erb 'vim/v-bin', :to => "/usr/bin/v".p
    shell 'chmod +x /usr/bin/v'
  end
end

dep 'sshd_accept_vimuser_env' do
  met? { '/etc/ssh/sshd_config'.p.grep(/^AcceptEnv VIMUSER/) }
  meet do 
    '/etc/ssh/sshd_config'.p.append("\n# Babushka added. Variable used in /usr/bin/v file") 
    '/etc/ssh/sshd_config'.p.append("\nAcceptEnv VIMUSER\n") 
  end
  after { shell 'service ssh reload', as: 'root' }
end
