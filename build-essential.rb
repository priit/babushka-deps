dep 'build-essential' do
  met? { shell('dpkg -l | grep "build-essential"') }
  meet { sudo 'apt-get install build-essential -y' }
end
