Fabricator(:proyecto_usuario) do
  proyecto { Fabricate(:proyecto) }
  usuario { Fabricate(:usuario) }
end