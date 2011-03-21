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
  
  def archive
    self.update_attributes({:archivado => true})
  end 

  def restore
    self.update_attributes({:archivado => false})    
  end

end
