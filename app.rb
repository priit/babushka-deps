# generic rails app
dep 'app', :username, :appname do
  username.ask("Username")
  appname.ask("New app name")

  requires 'rvm'.with(username)
  # requires 'app_dirs'.with(username, appname)
end

dep 'rvm' do
  met? do
    
  end

end

dep 'rvm', :username do
  met? do
    "/home/#{username}/.rvm/scripts/rvm".p.file?
  end

  meet do
    shell 'bash -c "`curl https://rvm.beginrescueend.com/install/rvm`"'
  end
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
