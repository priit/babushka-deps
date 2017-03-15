#
# Default app creates nginx/passenger stack
# Passenger will be installed by official deb
#
dep 'nginx_passenger' do
  requires 'nginx.lib'
  requires 'passenger.lib'
  requires 'enable-passenger'
end

dep 'enable-passenger' do
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
    '# include /etc/nginx/passenger.conf;'
  end

  def to_string
    'include /etc/nginx/passenger.conf;'
  end
end
