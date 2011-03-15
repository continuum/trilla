Fabricator(:temporizador) do |f|
  usuario { Fabricate(:usuario) }
  proyecto { Fabricate(:proyecto) }
  tarea { Fabricate(:tarea) }
end