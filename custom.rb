dep 'custom' do
  # set locale, US by default
  requires 'locales.conf'

  # set server env
  requires 'env'

  requires 'root_user_zshrc'

  # set priit vim
  requires 'vimrc_priit'
end
