Fabricator(:proyecto) do
  descripcion "Proyecto Uno"
  codigo "P1"
  estimacion "12"
  archivado false
  cliente { Fabricate(:cliente) }
end