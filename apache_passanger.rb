#
# Default app creates apache/passenger stack
# Passenger will be installed by official deb
#
dep 'apache_passenger' do
  requires 'apache.lib'
end
