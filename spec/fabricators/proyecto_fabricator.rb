Fabricator(:proyecto) do
  descripcion "Proyecto Uno"
  codigo "P1"
  estimacion "12"
  archivado false
  cliente(:force => true) { Fabricate(:cliente) }
end