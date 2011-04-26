Fabricator(:proyecto_tarea) do
  proyecto { Fabricate(:proyecto) }
  tarea { Fabricate(:tarea) }
end