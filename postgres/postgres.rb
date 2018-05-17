dep 'postgresql-9.6.managed' do 
  installs {
    via :apt, [
      "postgresql-9.6"
    ]
  }
  provides 'psql'
end

dep 'libpq-dev.lib'

dep 'postgres' do
  requires 'postgresql-9.6.managed'
  requires 'libpq-dev.lib'
end
