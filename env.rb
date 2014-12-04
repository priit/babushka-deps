dep 'env', :env do
  env.default('production').choose(%w[development staging production])

  met? do
    '/opt/development'.p.exists? ||
    '/opt/staging'.p.exists? ||
    '/opt/production'.p.exists?
  end

  meet do 
    sudo "touch /opt/#{env}" 
  end
end
