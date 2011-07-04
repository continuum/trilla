Fabricator(:contacto) do |f|
  nombre "Armando Casas"
  email "armando@casas.cl"
  telefono "123456"
  cliente(:force => true) { Fabricate(:cliente) }
end