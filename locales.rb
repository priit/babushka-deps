dep 'locales.conf'  do
  met? { '/etc/locale.gen'.p.grep(/^en\_US\.UTF\-8 UTF\-8/) }
  meet do
    append_to_file 'en_US.UTF-8 UTF-8', '/etc/locale.gen'
    shell '/usr/sbin/locale-gen'
  end
end
