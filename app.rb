# rails app
dep 'app', :username, :appname do
  username.ask("Username")
  appname.ask("New app name")

  # requires 'ruby_deps'.with(username)
  requires 'rben'.with(username)
  # requires 'rvm'.with(username)
  # requires 'app_dirs'.with(username, appname)
end

dep 'rbenv', :username do
  met? {
    in_path? 'rbenv'
  }
  meet {
    git 'https://github.com/sstephenson/rbenv.git', :to => "/home/#{username}/.rbenv"
    shell "chown #{username}:#{username} -R /home/#{username}/.rbenv"
  }
end

dep 'app_dirs', :username, :appname do
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
end

dep 'ruby_deps' do
  meet do
  shell 'apt-get install autoconf bison build-essential libssl-dev libyaml-dev' /
    'libreadline6-dev zlib1g-dev libncurses5-dev'

  after do
    log_shell "Autoremoving packages", "apt-get -y autoremove", :sudo => true
  end
end

