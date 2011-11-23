dep 'basic', :username, :password do
  username.ask("Additional user along root user:").default(shell('whoami'))
  password.ask("Additional user password")

  requires 'env'
  requires 'user'.with(username, password) if username != 'root'
  requires 'sudo'.with(username) if username != 'root'
  requires 'locales.conf'
  requires 'tree.managed'
  requires 'zip.managed'
  requires 'unzip.managed'

  requires 'hosts.conf'

  requires 'screen.conf'.with(username) if username != 'root'
  requires 'screen.confroot'

  requires 'zsh.conf'.with(username) if username != 'root'
  requires 'zsh.confroot'

  requires 'vim.conf'.with(username) if username != 'root'
  requires 'vim.confroot'

  if username != 'root'
    requires 'ssh.authorized_keys'.with(username, 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAz+n4Sln0oxme+9hyrgPud9k0C00Nm0T2YufHcQUAdtJssCfeKp2qo/gy0LmOXTB8efyavFn4NW2GZs8gxJ0BV5GoHLmnERAWDOi/wg3KLl4r/ei+HQX6Po/V7WOMHWzKPSSGtqW7cZc1g0y2ci571ZUmgEBoGoGPfoQToGEn2yV4hQmHIjbwtfNNCHx/i12DCoJnD+3cIvhHf4FbZRBW9Wu0I24iqLcxLOAwGWVsnzi0OqN+rj3DenPQfjcPhSsmTu+8mn2AIwMxWeLZSslEYfyBeo9dLBntj3dnxWpw/MJEfMmWgWKGqMaVGB731ZWDOrRrzgl5+s24YBv9LyYWyQ== aa@aa')
    requires 'ssh.authorized_keys-twice'.with(username, 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHnbu38ReMSotrQ3D8eQ6CGdOJ19M7RqpIrKED01+Me0wbOuotECcYkbgmQQzwF5SDuH4qINg8298Y55Fu6MBm/QDMJfnU7BZldAT+dyWgO3uJI2LJuH3ntuj9AdSdvc9IBDbOuFlAQ8/ANWS1lN3reoCkSShnZsD1CUIoL03/1ZBaYMKpiU9CRwhOPZUEaJ1Tmuyznuf9qUD6jF3iTrM6QIt0LaB++pNfBfkoRVOm3dkvc1hqoLm5GOzaWCnIk5XnFogZ50JEwWIINAW57eDXeOY/M5vBeBTv9ZjRFaAnLO6Z4U5pVSBhPKxKmwUWkq1rKT06O6FP/mrMP/D1x0Rd veiko@veiko')
  end

  requires 'ssh.conf'.with(username)
end

dep 'tree.managed' 
dep 'unzip.managed'
dep 'zip.managed'
