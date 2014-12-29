#
# Default app creates nginx/passenger stack
# Passenger will be installed under admin user
#
dep 'nginx_passenger', :username, :appname, :ruby_ver do
  # web server
  requires 'passenger' # installed under admin user, because core does not depend on ruby version
  requires 'nginx_init'
end
