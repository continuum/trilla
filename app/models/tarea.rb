class Tarea < ActiveRecord::Base
  has_many :proyecto_tareas
  has_many :proyectos, :through => :proyecto_tareas

  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para la tarea"
  validates_uniqueness_of :descripcion, :message => "Ya existe una tarea con el mismo nombre"

  named_scope :facturables, :conditions => "tipo = 'Facturable'"
  named_scope :no_facturables, :conditions => "tipo = 'No Facturable'"
  named_scope :ordered_by_tipo, :order => "tipo"
end
