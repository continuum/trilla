class ProyectoUsuario < ActiveRecord::Base
  belongs_to :proyecto
  belongs_to :usuario
end
