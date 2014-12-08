#
# ssh config
#
dep 'ssh_ask_all_authorized_keys', :username do
  met? do
    "/home/#{username}/.ssh/authorized_keys".p.grep(/^#{stamp}/)
  end

  meet do
    keys_path = Dir.glob("#{File.dirname(load_path)}/ssh/keys/*.pub")
    Dir.glob(keys_path).each do |file|
      filename = File.basename(file)
      if confirm("Should we add authorized key: #{filename} (y/n)", default: 'n')
        key = File.open(file, &:readline)
        requires 'ssh_authorized_key'.with(username, key)
      end
    end

    if confirm("Should we skip asking authorized keys next time? (y/n)", default: 'n')
      "/home/#{username}/.ssh/authorized_keys".p.append("\n#{stamp}\n")
    end
  end

  def keys
    "/home/#{username}/.ssh/authorized_keys"
  end

  def sudo?
    @sudo ||= username != shell('whoami')
  end

  def stamp
    "# Babushka: do not update this file"
  end
end

dep 'ssh_authorized_key', :username, :key do
  met? do
    shell? "fgrep '#{key}' '#{keys}'", :sudo => sudo?
  end

  meet do
    requires 'ssh_init_authorized_keys'.with(username)
    keys.p.append("# Babushka added key for #{username}\n")
    keys.p.append(key)
  end

  def keys
    "/home/#{username}/.ssh/authorized_keys"
  end

  def sudo?
    @sudo ||= username != shell('whoami')
  end
end

dep 'ssh_init_authorized_keys', :username do
  met? { "#{ssh_dir}/authorized_keys".p.exists? }
  meet do
    shell "mkdir -p -m 700 '#{ssh_dir}'" and
    shell "touch '#{ssh_dir}/authorized_keys'" and
    shell "chown -R #{username}:#{group} '#{ssh_dir}'" and
    shell "chmod 644 #{(ssh_dir / 'authorized_keys')}"
  end

  def ssh_dir
    "/home/#{username}/.ssh"
  end

  def group
    shell "id -gn #{username}"
  end
end

#
# sshd config
#
dep 'sshd_config', :username do
  met? { '/etc/ssh/sshd_config'.p.grep(/^# Generated by babushka/) }
  meet do
    '/etc/ssh/sshd_config'.p.copy('/etc/ssh/sshd_config.backup')
    render_erb 'ssh/sshd_config', :to => '/etc/ssh/sshd_config'
  end
  after { shell '/etc/init.d/ssh restart' }
end

dep 'sshd_user_env_on' do
  requires 'ssh.conf'

  met? { '/etc/ssh/sshd_config'.p.grep(/^PermitUserEnvironment yes/) }
  meet do 
    '/etc/ssh/sshd_config'.p.append('PermitUserEnvironment yes') 
  end
  after { shell '/etc/init.d/ssh restart' }
end
