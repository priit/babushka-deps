#
# Default app creates nginx/passenger stack
# Passenger will be installed by official deb
#
dep 'nginx_passenger' do
  requires 'nginx-extras.lib'
  requires 'passenger.lib'
  requires 'enable-passenger-root'
  requires 'enable-passenger-ruby'
end

dep 'enable-passenger-root' do
  met? do
    !path.p.grep(/#{from_string}/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/#{from_string}/#{to_string}/g' #{path}.backup > #{path}"
  end
  
  def path
    '/etc/nginx/nginx.conf'
  end

  def from_string
    '# passenger_root'
  end

  def to_string
    'passenger_root'
  end
end

dep 'enable-passenger-ruby' do
  met? do
    !path.p.grep(/#{from_string}/)
  end

  meet do 
    shell "cp #{path} #{path}.backup"
    shell "sed 's/#{from_string}/#{to_string}/g' #{path}.backup > #{path}"
  end
  
  def path
    '/etc/nginx/nginx.conf'
  end

  def from_string
    '# passenger_ruby'
  end

  def to_string
    'passenger_ruby'
  end
end
