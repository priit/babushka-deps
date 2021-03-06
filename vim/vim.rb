dep 'vim.managed'

dep 'vimrc_priit.copy' do
  requires 'vim.managed'
  requires 'v.copy'
  requires 'sshd_accept_vimuser_env'

  source 'vimrc-priit'
  path '/etc/vim/vimrc.local'
  comment '"'
end

dep 'v.copy' do
  source 'v-bin'
  path '/usr/bin/v'
  after { shell "chmod +x /usr/bin/v" }
end

dep 'sshd_accept_vimuser_env' do
  met? { '/etc/ssh/sshd_config'.p.grep(/^AcceptEnv VIMUSER/) }
  meet do 
    '/etc/ssh/sshd_config'.p.append("\n# Babushka added. Variable used in /usr/bin/v file") 
    '/etc/ssh/sshd_config'.p.append("\nAcceptEnv VIMUSER\n") 
  end
  after { shell 'service ssh reload', as: 'root' }
end
