dep 'locales.conf'  do
  met? { grep(/^en\_US\.UTF\-8 UTF\-8/, '/etc/locale.gen') }
  meet do
    append_to_file 'en_US.UTF-8 UTF-8', '/etc/locale.gen'
    shell '/usr/sbin/locale-gen'
  end
end
