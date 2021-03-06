require 'yaml'

dep 'gemrc', :username do
  met? do
    next false if !gemrc_path.p.exists?
    next true  if !shell?("grep '# Generated by babushka' #{gemrc_path}")

    shell? "diff -I '# Generated by babushka' #{source_path} #{gemrc_path}"
  end

  meet do
    render_erb 'gemrc', to: gemrc_path
    shell "chown #{username}:#{username} #{gemrc_path}"
  end

  def gemrc_path
    if username == 'root'
      "/root/.gemrc"
    else
      "/home/#{username}/.gemrc"
    end
  end

  def source_path
    @source_path ||= erb_path_for 'gemrc'
  end
end

# Passenger runtime is ruby version agnostic,
# thus no need to install under each user
# Passenger will use system default ruby
#
# Use official apt-get passenger if possible
dep 'gem-passenger' do
  requires 'ruby-dev.lib'
  requires 'libcurl4-openssl-dev.lib'

  met? do
    shell?("gem list --local passenger | grep passenger", as: 'root') # && so_path.p.exists?
  end

  meet do
    log_shell "Passenger gem install...",  "gem install --no-document passenger", as: 'root'
    log_shell "Passenger nginx install...",
      "passenger-install-nginx-module -a --languages ruby", as: 'root'
  end

  def latest_version
    spec = YAML.parse(shell("gem specification passenger"))
    spec.to_ruby.version.to_s
  end

  def path
    shell("gem env gemdir")
  end

  def so_path
    "#{path}/gems/passenger-#{latest_version}/ext/nginx/mod_passenger.so"
  end
end

dep 'gem-nginx_init' do
  met? do
    next false if !init_path.p.exists?
    next true  if !shell?("grep '# Generated by babushka' #{init_path}")

    shell? "diff -I '# Generated by babushka' #{source_path} #{init_path}"
  end

  meet do
    render_erb 'init_nginx', to: init_path
    shell "chmod +x #{init_path}"
  end

  def init_path
    "/etc/init.d/nginx"
  end

  def source_path
    @source_path ||= erb_path_for 'init_nginx'
  end
end
