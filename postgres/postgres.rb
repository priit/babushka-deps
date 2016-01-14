dep 'postgresql.managed'
dep 'libpq-dev.managed'

dep 'postgres' do
  requires 'postgresql'
  requires 'libpq-dev'
end

dep 'postgres94' do
  installs {
    via :apt, [
      "postgresql-9.4",
      "libpq-dev"
    ]
  }
end
