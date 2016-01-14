dep 'postgresql.bin'
dep 'libpq-dev.bin'

dep 'postgres' do
  requires 'postgresql.bin'
  requires 'libpq-dev.bin'
end

dep 'postgres94', template: 'bin' do
  installs {
    via :apt, [
      "postgresql-9.4",
      "libpq-dev"
    ]
  }
end
