dep 'ruby-dev.managed'
dep 'libcurl4-openssl-dev.managed'

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
