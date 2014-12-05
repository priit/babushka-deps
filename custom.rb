dep 'custom' do
  # set locale, US by default
  requires 'locales.conf'

  # set gitlab zsh
  requires 'zsh.confroot'

  # set gitlab vim
  requires 'vim.confroot'
end
