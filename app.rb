dep 'app', :username, :appname, :ruby_ver do
  @home_dirs = []
  Dir.glob('/home/*').sort.each do |dir|
    homename = dir.split('/').last
    next if homename == 'admin'
    @home_dirs << homename
  end

  username.default(@home_dirs.first).choose(@home_dirs)
  ruby_ver.default('2.2.0')
  appname.ask("Rails app name")

  # app env
  requires 'app_dirs'.with(username, appname)

  # ruby env
  requires 'ruby_deps'
  requires 'rbenv'.with(username)
  # requires 'ruby'.with('2.1.5')
  
  # postgres dev
  requires 'libpq-dev.lib'
end


#
# Low level deps
#

dep 'rbenv', :username do
  def path
    if username.nil?
      '/usr/local/rbenv'
    else
      "/home/#{username}/.rbenv"
    end
  end

  requires 'rbenv-core'.with(username, path)
  requires 'rbenv-ruby-build'.with(username, path)
  requires 'rbenv-bundler'.with(username, path)
end

dep 'rbenv-core', :username, :path do
  met? { path.p.exists? }
  meet { git 'https://github.com/sstephenson/rbenv.git', to: path }
  after { shell "chown #{username}:#{username} -R #{path}", as: 'root' }
end

dep 'rbenv-ruby-build', :username, :path do
  met? { "#{path}/plugins/ruby-build".p.exists? }
  meet { git 'https://github.com/sstephenson/ruby-build.git', to: "#{path}/plugins/ruby-build" }
  after { shell "chown #{username}:#{username} -R #{path}", as: 'root' }
end

dep 'rbenv-bundler', :username, :path do
  met? { "#{path}/plugins/bundler".p.exists? }
  meet { git 'https://github.com/carsomyr/rbenv-bundler.git', to: "#{path}/plugins/bundler" }
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


dep 'app_dirs', :username, :appname do
  def dirs
    %W(
      #{path}
      #{path}/current
      #{path}/releases
      #{path}/shared
      #{path}/shared/bundle
      #{path}/shared/config
      #{path}/shared/log
      #{path}/shared/pins
      #{path}/shared/tmp
      #{path}/shared/tmp/cache
    )
  end

  setup do
    if !"/home/#{username}".p.exists?
      unmeetable! 'This dep requires linux user should be present.' 
    end
  end

  met? do
    dirs.map {|d| d.p.exists?}.all?
  end

  meet do
    shell "mkdir #{dirs.join(' ')}", as: username
  end

  def path
    @path ||= "/home/#{username}/#{appname}"
  end

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

