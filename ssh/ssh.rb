#
# ssh user config
#

# for manual interactive usage
dep 'ssh_all_authorized_keys', :linux_user do
  requires 'ssh_init_authorized_keys_file'.with(linux_user)

  setup do
    if confirm("Should we add authorized keys? (y/n)", default: 'n')
      keys_path = Dir.glob("#{File.dirname(load_path)}/keys/*.pub")
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
    keys.each do |k|
      authorized_path.p.append(k)
    end
    authorized_path.p.append("# End of Babushka added keys\n")
    @keys = [] # let's keep met? happy
  end

  def authorized_path
    "/home/#{linux_user}/.ssh/authorized_keys"
  end

  def keys
    @keys ||= []
  end
end

dep 'ssh_authorized_keys', :linux_user, :key_names do
  linux_user.ask('Please provide linux username')
  key_names.ask('Please provide key names (comma separated)')
  requires 'ssh_init_authorized_keys_file'.with(linux_user)

  key_names.to_s.split(',').map(&:strip).each do |key_name|
    requires 'ssh_authorized_key'.with(linux_user, key_name)
  end
end

dep 'ssh_authorized_key', :linux_user, :key_name do
  linux_user.ask('Please provide linux username')
  key_name.ask('Please provide pub key name')

  met? do
    path.p.grep(key)
  end

  meet do
    path.p.append("#{key}/n")
  end

  def key
    key_file = "#{File.dirname(load_path)}/keys/#{key_name}.pub"
    File.open(key_file).first.to_s.strip
  end

  def path
    "/home/#{linux_user}/.ssh/authorized_keys"
  end
end

dep 'ssh_init_authorized_keys_file', :linux_user do
  met? { "#{ssh_dir}/authorized_keys".p.exists? }
  meet do
    shell "mkdir -p -m 700 '#{ssh_dir}'" and
    shell "touch '#{ssh_dir}/authorized_keys'" and
    shell "chown -R #{linux_user}:#{group} '#{ssh_dir}'" and
    shell "chmod 644 #{(ssh_dir / 'authorized_keys')}"
  end

  def ssh_dir
    "/home/#{linux_user}/.ssh"
  end

  def group
    shell "id -gn #{linux_user}"
  end
end

#
# sshd config
#

# Use it when starting updating sshd_config
dep 'sshd_config_day_backup' do
  met? do
    "/etc/ssh/sshd_config-#{Date.today}".p.exists?
  end
  meet do
    shell "cp /etc/ssh/sshd_config /etc/ssh/sshd_config-#{Date.today}"
  end
end

dep 'sshd_password_should_be_off' do
  met? do
    path.p.grep(/^PasswordAuthentication no/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/.*PasswordAuthentication .*/PasswordAuthentication no/g' #{path}.backup > #{path}"
  end
  after { shell '/etc/init.d/ssh restart' }
  
  def path
    '/etc/ssh/sshd_config'
  end
end

dep 'sshd_root_login_should_be_off' do
  met? do
    path.p.grep(/^PermitRootLogin no/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/.*PermitRootLogin .*/PermitRootLogin no/g' #{path}.backup > #{path}"
  end
  after { shell '/etc/init.d/ssh restart' }
  
  def path
    '/etc/ssh/sshd_config'
  end
end

dep 'sshd_pam_should_be_off' do
  met? do
    path.p.grep(/^UsePAM no/)
  end

  meet do
    shell "cp #{path} #{path}.backup"
    shell "sed 's/.*UsePAM .*/UsePAM no/g' #{path}.backup > #{path}"
  end
  after { shell '/etc/init.d/ssh restart' }

  def path
    '/etc/ssh/sshd_config'
  end
end
