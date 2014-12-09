dep 'vim.managed'

dep 'vimrc_priit' do
  requires 'vim.managed'
  requires 'v.bin'
  requires 'sshd_user_env_on'

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

dep 'sshd_user_env_on' do
  requires 'ssh.conf'

  met? { '/etc/ssh/sshd_config'.p.grep(/^PermitUserEnvironment yes/) }
  meet do 
    '/etc/ssh/sshd_config'.p.append('PermitUserEnvironment yes') 
  end
  after { shell '/etc/init.d/ssh restart' }
end

