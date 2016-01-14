dep 'postgresql.bin' do 
  installs 'postgres-9.4'
end

dep 'libpq-dev.managed'

dep 'postgres' do
  requires 'postgresql.bin'
  requires 'libpq-dev.managed'
end

dep 'postgres94', template: 'bin' do
  installs {
    via :apt, [
      "postgresql-9.4",
      "libpq-dev"
    ]
  }
end
