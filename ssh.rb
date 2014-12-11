#
# ssh config
#
dep 'ssh_all_authorized_keys', :username do
  requires 'ssh_init_authorized_keys_file'.with(username)

  setup do
    if confirm("Should we add authorized keys? (y/n)", default: 'n')
      keys_path = Dir.glob("#{File.dirname(load_path)}/ssh/keys/*.pub")
      Dir.glob(keys_path).sort.each do |file|
        filename = File.basename(file)
        if confirm("Should we add: #{filename} (y/n)", default: 'n')
          keys << File.open(file, &:readline)
        end
      end
    end
  end

  met? do
    keys.size == 0
  end

  meet do
    authorized_path.p.append("# Babushka added keys\n")
    authorized_path.p.append(keys.join('\n'))
    authorized_path.p.append("# End of Babushka added keys\n")
    @keys = [] # let's keep met? happy
  end

  def authorized_path
    "/home/#{username}/.ssh/authorized_keys"
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

# global one config for all
dep 'sshd_config', :username do
  met? do
    '/etc/ssh/sshd_config'.p.grep(/^# Generated by babushka/)
  end 
  meet do
    '/etc/ssh/sshd_config'.p.copy('/etc/ssh/sshd_config.backup')
    render_erb 'ssh/sshd_config', :to => '/etc/ssh/sshd_config'
  end
  after { shell '/etc/init.d/ssh restart' }
end

dep 'sshd_password_should_be_off' do
  met? do
    path.p.grep(/PasswordAuthentication no/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/^PasswordAuthentication .*/PasswordAuthentication no/g' #{path}.backup > #{path}"
  end
  after { shell '/etc/init.d/ssh restart' }
  
  def path
    '/etc/ssh/sshd_config'
  end
end

dep 'sshd_root_login_should_be_off' do
  met? do
    path.p.grep(/PermitRootLogin no/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/PermitRootLogin .*/PermitRootLogin no/g' #{path}.backup > #{path}"
  end
  after { shell '/etc/init.d/ssh restart' }
  
  def path
    '/etc/ssh/sshd_config'
  end
end
