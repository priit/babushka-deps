# rails app
dep 'app', :username, :appname do
  @homenames = []
  Dir.glob('/home/*').sort.each do |dir|
    homename = dir.split('/').last
    next if homename == 'admin'
    @homenames << homename
  end

  username.default(@homenames.first).choose(@homenames)
  appname.ask("New app name")

  requires 'ruby_deps'
  requires 'rbenv'.with(username)
  # requires 'ruby-build'.with(username)
  # requires 'rvm'.with(username)
  # requires 'app_dirs'.with(username, appname)
end

dep 'rbenv', :username do
  met? {
    "/home/#{username}/.rbenv".p.exists?
  }
  meet {
    git 'https://github.com/sstephenson/rbenv.git', :to => "/home/#{username}/.rbenv"
    shell "chown #{username}:#{username} -R /home/#{username}/.rbenv"
  }
end

dep 'app_dirs', :username, :appname do
  def dirs
    w%(
      #{path}
      #{path}/current
      #{path}/releases
      #{path}/shared
      #{path}/shared/bundle
      #{path}/shared/config
      #{path}/shared/log
      #{path}/shared/pins
      #{path}/shared/tmp
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
    shell "mkdir #{dirs.join(' ')}"
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
    )
  end

  met? do
    shell? "dpkg --status #{list.join(' ')}"
  end

  meet do
    shell "apt-get --yes install #{list.join(' ')}"
  end

  after do
    log_shell "Autoremoving packages", "apt-get -y autoremove", :sudo => true
  end
end
