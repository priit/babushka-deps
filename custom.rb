dep 'custom' do
  # set locale, US by default
  requires 'locales.conf'

  requires 'root_user_zshrc'

  # set priit vim
  requires 'vimrc_priit'
end
