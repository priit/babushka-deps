dep 'build-essential.managed'
dep 'binutils-doc.manage'

dep 'build-essential' do
  requires 'build-essential.managed'
  requires 'binutils-doc.manage'
end
