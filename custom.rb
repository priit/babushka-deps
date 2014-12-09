dep 'custom' do
  # set locale, US by default
  requires 'set_us_locale'

  # set server env such as production
  requires 'env'

  # add root zshrc
  requires 'root_user_zshrc'

  # add v bin and priit vim
  requires 'vimrc_priit'

  # cleanup ssh welcome text
  requires 'motd_empty'

  # verify ssh root login is off
  requires 'sshd_root_login_should_be_off'

  # verify ssh password login is off
  requires 'sshd_password_should_be_off'

  # add admin password, amazon debian ec2 stuff
  requires 'admin_password'

  # admin should also ask passowrd, amazon debian ec2 stuff
  requires 'replace_default_admin_sudoer'
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

dep 'admin_password', :password do
  setup do
    unmeetable! 'This dep must be run as root.' unless shell('whoami') == 'root'
    shell('sudo -k') # expire an existing cached password
    if shell?('sudo -n true')
      @add_it = true if confirm('Root user does not have password, should we add it? (y/n)', default: 'n')
    end
  end

  met? do
    if @add_it
      shell('sudo -k') # expire an existing cached password
      !shell?('sudo -n true')
    else
      true
    end
  end

  meet do
    password.ask('Root user password')
    shell "echo 'admin:#{password}' | chpasswd"
  end
end

dep 'replace_default_admin_sudoer' do
  met? do
    path.p.exists?
  end 

  meet do 
    filename.p.write("admin ALL=(ALL:ALL) ALL") 
    if shell "visudo -cf #{filename}"
      shell "mv #{filename} #{path}"
    else
      puts 'Syntax error in new sudoers file'
    end
  end

  def path
    "/etc/sudoers.d/#{filename}"
  end

  def filename
    "90-cloud-init-users"
  end
end
