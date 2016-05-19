dep 'rbenv', :username do
  @home_dirs = []
  Dir.glob('/home/*').sort.each do |dir|
    homename = dir.split('/').last
    next if homename == 'admin'
    @home_dirs << homename
  end

  username.ask('Which user?').default(@home_dirs.first)

  # ruby env
  requires 'ruby_deps'
  requires 'rbenv-stack'.with(username)
  
  # postgres dev
  requires 'libpq-dev.lib'
end

#
# Low level deps
#

dep 'rbenv-stack', :username do
  def path
    if username.nil?
      '/usr/local/rbenv'
    else
      "/home/#{username}/.rbenv"
    end
  end

  requires 'rbenv-core'.with(username, path)
  requires 'rbenv-ruby-build'.with(username, path)
end

dep 'rbenv-core', :username, :path do
  met? { path.p.exists? }
  meet { git 'https://github.com/rbenv/rbenv.git', to: path }
  after { shell "chown #{username}:#{username} -R #{path}", as: 'root' }
end

dep 'rbenv-ruby-build', :username, :path do
  met? { "#{path}/plugins/ruby-build".p.exists? }
  meet { git 'https://github.com/rbenv/ruby-build.git', to: "#{path}/plugins/ruby-build" }
  after { shell "chown #{username}:#{username} -R #{path}", as: 'root' }
end

dep 'ruby', :version do
  requires 'rbenv'
  met? {
    # check for right system ruby in rbenv
    if login_shell "rbenv versions | grep '#{version}' 1>/dev/null 2>&1"
      log_ok "ruby version=#{version}"
    end
  }
  meet {
    # install system ruby in rbenv
    login_shell "rbenv install #{version}"
    log "ruby version=#{version}"
  }
  after {
    login_shell 'rbenv rehash'
    login_shell "rbenv global #{version}"
  }
end

dep 'ruby_deps' do
  def list
    %w(
      autoconf
      bison
      build-essential
      libssl-dev
      libyaml-dev
      libreadline6-dev
      zlib1g-dev
      libncurses5-dev
      libffi-dev
    )
  end

  met? do
    shell?("dpkg --status #{list.join(' ')}", as: 'root')
  end

  meet do
    shell "apt-get --yes install #{list.join(' ')}", sudo: true
  end

  # after do
    # shell "Autoremoving packages", "apt-get -y autoremove", sudo: true
  # end
end

