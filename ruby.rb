dep 'ruby-dep' do
  # don't know how to test it
  met? { false }
  meet do 
    sudo 'apt-get build-dep ruby1.9.1 -y'
  end
end
