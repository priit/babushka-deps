dep 'custom' do
  # set locale, US by default
  requires 'locales.conf'

  # set server env such as production
  requires 'env'

  # add root zshrc
  requires 'root_user_zshrc'

  # add v bin and priit vim
  requires 'vimrc_priit'

  # cleanup ssh welcome text
  requires 'motd_empty'

  # verify ssh UsePAM is off
  requires 'sshd_pam_should_be_off'
end


# cleanup ssh welcome text
dep 'motd_empty' do
  met? do
    "/etc/motd".p.empty?
  end

  meet do
    shell "mv /etc/motd /etc/motd.old"
  end
end
