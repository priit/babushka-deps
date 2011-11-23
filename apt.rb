dep 'apt' do
  met? { grep(/^# Generated by babushka/, '/etc/apt/sources.list') }
  meet do
    '/etc/apt/sources.list'.p.copy('/etc/apt/sources.list.backup')
    render_erb 'apt/sources.list', :to => '/etc/apt/sources.list'
  end
  after { shell 'apt-get update' }
end

dep 'apt.upgrade' do
  requires 'apt'

  met? { false }
  meet do
    sudo 'apt-get upgrade -y'
  end
end
