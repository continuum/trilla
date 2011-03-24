class Cliente < ActiveRecord::Base
  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para el cliente"
end

class ClienteObj
  
  attr_accessor :id
  attr_accessor :descripcion
  attr_accessor :proyectos
  
end
