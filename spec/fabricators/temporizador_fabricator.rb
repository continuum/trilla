Fabricator(:temporizador) do |f|
  usuario { Fabricate(:usuario) }
  proyecto { Fabricate(:proyecto)}
  tarea { Fabricate(:tarea)}
  iniciado 1
  minutos 0
end