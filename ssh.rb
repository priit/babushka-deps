dep 'ssh.conf', :username do
  met? { grep(/^# Generated by babushka/, '/etc/ssh/sshd_config') }
  meet do
    '/etc/ssh/sshd_config'.p.copy('/etc/ssh/sshd_config.backup')
    render_erb 'ssh/sshd_config', :to => '/etc/ssh/sshd_config'
  end
  after { shell '/etc/init.d/ssh restart' }
end

dep 'ssh.init_authorized_keys', :username do
  def ssh_dir
    "~#{username}" / '.ssh'
  end

  def group
    shell "id -gn #{username}"
  end

  def sudo?
    @sudo ||= username == shell('whoami')
  end

  met? { "#{ssh_dir}/authorized_keys".p.exists? }
  meet do
    shell "mkdir -p -m 700 '#{ssh_dir}'", :sudo => sudo? 
    shell "touch '#{ssh_dir}/authorized_keys'", :sudo => sudo?
    sudo "chown -R #{username}:#{group} '#{ssh_dir}'" unless ssh_dir.owner == username
    shell "chmod 644 #{(ssh_dir / 'authorized_keys')}", :sudo => sudo?
  end
end

dep 'ssh.authorized_keys', :username, :key do
  requires 'ssh.init_authorized_keys'.with(username)
  key.ask('Please provide SSH key')

  def ssh_dir
    "~#{username}" / '.ssh'
  end

  def group
    shell "id -gn #{username}"
  end

  def sudo?
    @sudo ||= username == shell('whoami')
  end

  met? { grep(/aa@aa|veiko@veiko/, "#{ssh_dir}/authorized_keys") }
  #met? { grep(/#{key.to_s.split[2]}/, "#{ssh_dir}/authorized_keys") }
  meet { append_to_file key, (ssh_dir / 'authorized_keys'), :sudo => sudo? }
end

# how to run twice?
dep 'ssh.authorized_keys-twice', :username, :key do
  #username.default(shell('whoami'))
  requires 'ssh.init_authorized_keys'.with(username)
  key.ask('Please provide second SSH key')

  def ssh_dir
    "~#{username}" / '.ssh'
  end

  def group
    shell "id -gn #{username}"
  end

  def sudo?
    @sudo ||= username == shell('whoami')
  end

  met? { grep(/aa@aa|veiko@veiko/, "#{ssh_dir}/authorized_keys") }
  #met? { grep(/#{key.to_s.split[2]}/, "#{ssh_dir}/authorized_keys") }
  meet { append_to_file key, (ssh_dir / 'authorized_keys'), :sudo => sudo? }
end

