dep 'user', :user, :password do
  requires 'zsh'
  requires 'group'.with(user)
  password.ask("Creane a new user #{user} password:")

  met? { '/etc/passwd'.p.grep(/^#{user}:/) }
  meet {
    sudo "useradd --create-home --shell /bin/zsh --base-dir /home --groups #{user}" and
    sudo "chmod 701 /home/#{user}" and
    sudo "chown #{user}:#{user} -R /home/#{user}" and
    sudo %{echo "#{password}\n#{password}" | passwd #{user}}
  }
end

dep 'group', :group do
  met? { '/etc/group'.p.grep(/^#{group}:/) }
  meet { sudo "groupadd #{group}" }
end
