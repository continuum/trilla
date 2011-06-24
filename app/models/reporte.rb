class Reporte < ActiveRecord::Base
  validates_presence_of :nombre, :message => "Debe ingresar un nombre para el reporte"
  validates_presence_of :descripcion, :message => "Debe ingresar un descripción para el reporte"
  validates_presence_of :query, :message => "Debe ingresar una query para el reporte"
  validates_presence_of :tipo, :message => "Debe ingresar el tipo del reporte"

  def self.tipos
    tipos = ActiveRecord::Base.connection.execute('SELECT distinct(r.tipo) FROM reportes r where r.tipo is not null').to_a
    tipos.map do |row|
      row['tipo']
    end
  end
end
