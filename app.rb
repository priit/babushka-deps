#
# Default app creates passenger/nginx stack
# Note: passenger will be installed under admin user
#
dep 'app', :username, :appname do
  @home_dirs = []
  Dir.glob('/home/*').sort.each do |dir|
    homename = dir.split('/').last
    next if homename == 'admin'
    @home_dirs << homename
  end

  username.default(@home_dirs.first).choose(@home_dirs)
  appname.ask("Rails app name")

  requires 'ruby_deps'
  requires 'rbenv'.with(username)
  requires 'app_dirs'.with(username, appname)
  requires 'passenger' # installed under admin user, because core does not depend on ruby version
  requires 'nginx_init'
end


#
# Low level deps
#

dep 'rbenv', :username do
  met? {
    path.p.exists? &&
    "#{path}/plugins/ruby-build".p.exists? &&
    "#{path}/plugins/bundler".p.exists?
  }
  meet {
    git 'https://github.com/sstephenson/rbenv.git', to: path
    git 'https://github.com/sstephenson/ruby-build.git', to: "#{path}/plugins/ruby-build"
    git 'https://github.com/carsomyr/rbenv-bundler.git', to: "#{path}/plugins/bundler"
    shell "chown #{username}:#{username} -R /home/#{username}/.rbenv"
  }

  def path
    "/home/#{username}/.rbenv"
  end
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
    shell "apt-get --yes install #{list.join(' ')}", sudo: true
  end

  after do
    shell "Autoremoving packages", "apt-get -y autoremove", sudo: true
  end
end

