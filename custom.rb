dep 'custom' do
  # set locale, US by default
  requires 'locales.conf'

  # set server env
  requires 'env'

  requires 'root_user_zshrc'

  # set priit vim
  requires 'vimrc_priit'

  # cleanup ssh welcome text
  requires 'motd-empty'
end


# cleanup ssh welcome text
dep 'motd_empty' do
  met? do
    "/etc/motd".p.present?
  end

  meet do
    shell "mv /etc/motd /etc/motd.old"
  end
end
