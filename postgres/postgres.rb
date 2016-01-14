dep 'postgresql-9.4.bin' do 
  installs {
    via :apt, [
      "postgresql-9.4",
      "libpq-dev"
    ]
  }
end

dep 'libpq-dev.managed'

dep 'postgres' do
  requires 'postgresql-9.4.bin'
  requires 'libpq-dev.managed'
end

# dep 'postgres94', template: 'bin' do
  # installs {
    # via :apt, [
      # "postgresql-9.4",
      # "libpq-dev"
    # ]
  # }
# end
