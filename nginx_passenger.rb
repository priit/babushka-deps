#
# Default app creates nginx/passenger stack
# Passenger will be installed by official deb
#
dep 'nginx_passenger' do
  requires 'nginx-extras.lib'
  requires 'passenger.lib'
end
