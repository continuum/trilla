class ProyectoTarea < ActiveRecord::Base
  belongs_to :proyecto
  belongs_to :tarea
end
