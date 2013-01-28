dep 'locales.conf'  do
  met? { '/etc/locale.gen'.p.grep(/^en\_US\.UTF\-8 UTF\-8/) }
  meet do
    '/etc/locale.gen'.p.append('en_US.UTF-8 UTF-8')
    shell '/usr/sbin/locale-gen'
  end
end
