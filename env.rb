dep 'env' do
  env ||= 'production'
  env.default('production').choose(%w[development staging production])

  met? do
    '/etc/development'.p.exists? ||
    '/etc/staging'.p.exists? ||
    '/etc/production'.p.exists?
  end

  meet do 
    sudo "touch /etc/#{env}" 
  end
end
