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
    shell? "diff #{source_path} #{path}"
  end

  meet do
    render_erb 'zsh/zshrc', :to => "/home/#{username}/.zshrc".p
    shell "chown #{username}:#{username} /home/#{username}/.zshrc"
  end

  def path
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
