# ec2 debian specific
dep 'custom' do
  # set locale, US by default
  requires 'set_us_locale'

  # set server env such as production
  requires 'env'

  # add root zshrc
  requires 'zshrc'.with('root')

  # add root gemrc
  requires 'gemrc'.with('root')

  # add v bin and priit vim
  requires 'vimrc_priit.copy'

  # cleanup ssh welcome text
  requires 'motd_empty'

  # verify ssh root login is off
  requires 'sshd_root_login_should_be_off'

  # verify ssh password login is off
  requires 'sshd_password_should_be_off'
end


# cleanup ssh welcome text
dep 'motd_empty' do
  met? do
    !"/etc/motd".p.exists?
  end

  meet do
    shell "mv /etc/motd /etc/motd.old"
  end
end

# env
dep 'env', :env do
  env.default('production').choose(%w[development staging production])

  met? do
    '/opt/development'.p.exists? ||
    '/opt/staging'.p.exists? ||
    '/opt/production'.p.exists?
  end

  meet do 
    sudo "touch /opt/#{env}" 
  end
end

# locale
dep 'set_us_locale'  do
  met? { '/etc/locale.gen'.p.grep(/^en\_US\.UTF\-8 UTF\-8/) }
  meet do
    '/etc/locale.gen'.p.append('en_US.UTF-8 UTF-8')
    shell '/usr/sbin/locale-gen'
  end
end
