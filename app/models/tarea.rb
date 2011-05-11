class Tarea < ActiveRecord::Base
  has_many :proyecto_tareas
  has_many :proyectos, :through => :proyecto_tareas

  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para la tarea"
  validates_uniqueness_of :descripcion, :message => "Ya existe una tarea con el mismo nombre"
  validates_inclusion_of :tipo, :in => ['Facturable', 'No Facturable'], :message => "Valores válidos de tipo: 'Facturable', 'No Facturable'"

  named_scope :facturables, :conditions => "tipo = 'Facturable'"
  named_scope :no_facturables, :conditions => "tipo = 'No Facturable'"
  named_scope :ordered_by_tipo, :order => "tipo"

  def before_destroy
    if Tarea.cantidad_proyectos(self.id) > 0
      errors.add_to_base "La tarea ha sido referenciada desde un proyecto"
      false
    end
  end
  
  def self.cantidad_proyectos(tarea_id)
    Proyecto.count( 
      :joins => "left join proyecto_tareas on proyectos.id = proyecto_tareas.proyecto_id",
      :conditions =>["tarea_id = ?", tarea_id]
      )
  end
  
  def self.find_by_clientes_proyectos(cp)
    find( :all,
          :select => "distinct tareas.*",
          :joins => "left join proyecto_tareas on proyecto_tareas.tarea_id = tareas.id",
          :conditions => ["proyecto_tareas.proyecto_id in (?)", cp.map{|c| c.proyectos }.flatten.map{|p| p.id}],
          :order => "tipo"
    )
  end

end
