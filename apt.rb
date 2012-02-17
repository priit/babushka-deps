dep 'apt' do
  met? do
    return trud if grep(/^# Generated by babushka/, '/etc/apt/sources.list')
    ask("Sould we add Debian Squeeze source list? (y/n):") == "y"
  end

  meet do
    '/etc/apt/sources.list'.p.copy('/etc/apt/sources.list.backup')
    render_erb 'apt/sources.list', :to => '/etc/apt/sources.list'
  end
  after { sudo 'apt-get update -y' }
end

dep 'apt.upgrade' do
  requires 'apt'

  # does not work at the moment
  #met? { true }
  #meet do
    #sudo 'apt-get upgrade -y'
  #end
end
