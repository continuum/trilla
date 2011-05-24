class Proyecto < ActiveRecord::Base
  belongs_to :cliente
  has_many :proyecto_tareas
  has_many :tareas, :through => :proyecto_tareas
  accepts_nested_attributes_for :proyecto_tareas, :reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true

  
  has_many :proyecto_usuarios
  has_many :usuarios, :through => :proyecto_usuarios
  accepts_nested_attributes_for :proyecto_usuarios, :reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true


  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para el proyecto"
  validates_uniqueness_of :descripcion, :message => "Ya existe un proyecto con el mismo nombre"
  validates_numericality_of :cliente_id, :greater_than => 0, :message => "Debe seleccionar un cliente"
  #validates_associated :tareas
  #validates_associated :cliente

  named_scope :no_archivados, :conditions => "not archivado"
  
  def validate
    if self.privado == true && self.proyecto_usuarios.size <= 0 && self.usuarios.size <= 0
      errors.add_to_base "Debe asociar al menos un usuario a un proyecto privado"
      false
    end
  end
  
  def self.find_all_accesibles(usuario_id)
   # find(
   #   :all, 
   #   :joins => "left join proyecto_usuarios on proyecto_usuarios.proyecto_id = proyectos.id", 
   #   :conditions => ["privado = false or privado is null or proyecto_usuarios.usuario_id = ?", usuario_id]
   # )
   #TODO:  BUG N°: 13273349
   #        Probablemente existe una mejor forma de conseguir la unicidad de proyectos
   #        utilizando algo un poco más abstraido como la llamada comentada de arriba.
   find_by_sql("SELECT  DISTINCT proyectos.descripcion,
                                 proyectos.id,
                                 proyectos.cliente_id,
                                 proyectos.created_at,
                                 proyectos.updated_at,
                                 proyectos.archivado,
                                 proyectos.codigo,
                                 proyectos.estimacion,
                                 proyectos.privado
                               FROM proyectos left join proyecto_usuarios on proyecto_usuarios.proyecto_id = proyectos.id
                               WHERE privado = false or privado is null or proyecto_usuarios.usuario_id = #{usuario_id}")
  end
  
  def archive
    self.update_attributes({:archivado => true})
  end 

  def restore
    self.update_attributes({:archivado => false})    
  end

end
