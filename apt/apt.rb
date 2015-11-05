dep 'nginx.lib' do
  requires 'passenger-source-list'
  installs {
    via :apt, 'nginx-extras'
  }
end

dep 'apache.lib' do
  requires 'passenger-source-list'
  installs {
    via :apt, 'libapache2-mod-passenger'
  }
  after {
    shell 'sudo a2enmod passenger; sudo service apache2 restart'
  }
end

dep 'passenger.lib' do
  requires 'passenger-source-list'
  installs {
    via :apt, 'passenger'
  }
end

dep 'libpq-dev.lib' do
  installs {
    via :apt, 'libpq-dev'
  }
end

dep 'passenger-source-list' do
  requires 'passenger-repo-key'

  met? {
    path.p.grep(/^# Generated by babushka/)
  }
  meet {
    debian_version = "debian-#{shell("cat /etc/debian_version").to_i}"
    render_erb "passenger.list.#{debian_version}", :to => path
    Babushka::AptHelper.update_pkg_lists "Updating apt lists to load Passenger sources."
  }

  def path
    '/etc/apt/sources.list.d/passenger.list'
  end
end

dep 'ruby-dev.lib' do
  installs {
    via :apt, 'ruby-dev'
  }
end

dep 'libcurl4-openssl-dev.lib' do
  installs {
    via :apt, 'libcurl4-openssl-dev'
  }
end

dep 'apt-transport-https.lib' do
  installs {
    via :apt, 'apt-transport-https'
  }
end

dep 'ca-certificates.lib' do
  installs {
    via :apt, 'ca-certificates'
  }
end

dep 'passenger.lib' do
  requires 'passenger-repo-key'
  requires 'passenger-source-list'

  met? {
    shell?("sudo apt-key list | grep 'Phusion Automated Software Signing'", as: 'root')
  }
  meet {
    shell "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7",
      sudo: true
  }
end

dep 'passenger-repo-key' do
  requires 'apt-transport-https.lib'
  requires 'ca-certificates.lib'

  met? {
    shell?("sudo apt-key list | grep 'Phusion Automated Software Signing'", as: 'root')
  }
  meet {
    shell "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7",
      sudo: true
  }
end



# dep 'apt' do
  #met? do
    #if '/etc/apt/sources.list'.p.grep(/^# Generated by babushka/)
      #true
    #else
      #confirm("Sould we change to simple source list for Debian? (y/n):") == "y"
    #end
  #end

  #meet do
    #'/etc/apt/sources.list'.p.copy('/etc/apt/sources.list.backup')
 
    #debian_version = shell('cat /etc/debian_version').split('/').first
    #render_erb "apt/sources.list.#{debian_version}", :to => '/etc/apt/sources.list'
  #end

  #after { sudo 'apt-get update -y' }

  # met? do
    # confirm("Should we do apt-get update? (y/n):")
  # end

  # meet do
    # sudo 'apt-get update -y'
  # end
# end