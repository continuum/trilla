class ProyectoContacto < ActiveRecord::Base
  belongs_to :contacto
  belongs_to :proyecto
end
