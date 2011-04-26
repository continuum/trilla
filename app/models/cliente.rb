class Cliente < ActiveRecord::Base
  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para el cliente"
  
  def before_destroy
    if Cliente.cantidad_proyectos(self.id) > 0
      errors.add_to_base "El cliente posee proyectos asociados"
      false
    end
  end
  
  def self.cantidad_proyectos(cliente_id)
    Proyecto.count :conditions =>["cliente_id = ?", cliente_id]
  end
  
end

class ClienteObj
  
  attr_accessor :id
  attr_accessor :descripcion
  attr_accessor :proyectos
  
end
