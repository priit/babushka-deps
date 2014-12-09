#
# ssh config
#
dep 'ssh_authorized_keys_lock', :username do
  met? do
    return true if "/home/#{username}/.ssh/authorized_keys".p.grep(/^#{stamp}/)
    confirm("Should we skip asking authorized keys next time? (y/n)", default: 'n')
  end

  meet do
    "/home/#{username}/.ssh/authorized_keys".p.append("#{stamp}\n")
  end
end

dep 'ssh_all_authorized_keys', :username do
  requires 'ssh_init_authorized_keys_file'.with(username)

  setup do
    keys_path = Dir.glob("#{File.dirname(load_path)}/ssh/keys/*.pub")
    Dir.glob(keys_path).each do |file|
      filename = File.basename(file)
      if confirm("Should we add authorized key: #{filename} (y/n)", default: 'n')
        keys << File.open(file, &:readline)
      end
    end
  end

  met? do
    keys.size == 0
  end

  meet do
    authorized_path.p.append("# Babushka managed keys\n")
    keys.each do |key|
      authorized_path.p.append(keys.join('\n'))
      keys.delete(key)
    end
    authorized_path.p.append("# End of Babushka managed keys\n")
  end

  def authorized_path
    "/home/#{username}/.ssh/authorized_keys"
  end

  def stamp
    "# Babushka: do not update this file"
  end

  def keys
    @keys ||= []
  end
end

dep 'ssh_init_authorized_keys_file', :username do
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
