#
# Certbot
# 
#
dep 'certbot' do
  requires 'apt-backports-list'
  requires 'certbot_create_webroot_path'
end

dep 'certbot_create_webroot_path' do
  met? { "/usr/share/nginx/html/.well-known/acme-challenge".p.exists? }
  meet do
    shell "mkdir -p /usr/share/nginx/html/.well-known/acme-challenge"
  end
end

# then manually
# sudo apt-get install certbot -t jessie-backports
# certbot certonly --webroot -w /usr/share/nginx/html -d test.example.com,test1.example.com
