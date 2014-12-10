dep 'zsh.managed'

dep 'zsh', :username do
  requires 'zsh.managed'
  username.default!(shell('whoami'))

  met? { shell("sudo su - '#{username}' -c 'echo $SHELL'") == which('zsh') }
  meet { sudo("chsh -s '#{which('zsh')}' #{username}") }
end

dep 'zshrc', :username do
  requires 'zsh'.with(username)

  met? do
    log_shell? "diff #{source_path} #{zshrc_path}"
  end

  meet do
    render_erb 'zsh/zshrc', to: zshrc_path
    shell "chown #{username}:#{username} #{zshrc_path}"
  end

  def zshrc_path
    if username == 'root'
      '/root/.zshrc'
    else
      "/home/#{username}/.zshrc"
    end
  end

  def source_path
    @source_path ||= erb_path_for 'zsh/zshrc'
  end
end
