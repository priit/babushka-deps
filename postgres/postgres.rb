dep 'postgresql.managed'
dep 'libpq-dev.managed'

dep 'postgres' do
  requires 'postgresql.managed'
  requires 'libpg-dev.managed'
end
