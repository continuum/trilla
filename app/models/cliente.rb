class Cliente < ActiveRecord::Base
  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para el cliente"
  
  def before_destroy
    if cantidad_proyectos > 0
      errors.add_to_base "El cliente posee proyectos asociados"
      false
    end
  end
  
  def cantidad_proyectos
    Proyecto.count :conditions =>["cliente_id = ?", self.id]
  end
  
end

class ClienteObj
  
  attr_accessor :id
  attr_accessor :descripcion
  attr_accessor :proyectos
  
end
