dep 'postgresql-9.4.managed' do 
  installs {
    via :apt, [
      "postgresql-9.4"
    ]
  }
  provides 'psql'
end

dep 'libpq-dev.lib'

dep 'postgres' do
  requires 'postgresql-9.4.managed'
  requires 'libpq-dev.lib'
end

# dep 'postgres94', template: 'bin' do
  # installs {
    # via :apt, [
      # "postgresql-9.4",
      # "libpq-dev"
    # ]
  # }
# end
