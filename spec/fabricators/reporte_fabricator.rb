Fabricator(:reporte) do |f|
  nombre "Reporte de Tiempos 2011"
  descripcion "Reporte oficial de tiempos"
  tipo "Tipo del reporte"
  query "SELECT * FROM temporizadors"
  created_at Time.now
  updated_at Time.now
end