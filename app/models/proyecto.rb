class Proyecto < ActiveRecord::Base
  belongs_to :cliente
  has_many :proyecto_tareas
  has_many :tareas, :through => :proyecto_tareas
  accepts_nested_attributes_for :proyecto_tareas, :reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true

  
  has_many :proyecto_usuarios
  has_many :usuarios, :through => :proyecto_usuarios
  accepts_nested_attributes_for :proyecto_usuarios, :reject_if => lambda { |a| a.values.all?(&:blank?) }, :allow_destroy => true


  validates_presence_of :descripcion, :message => "Se debe ingresar un nombre para el proyecto"
  validates_associated :tareas

  named_scope :no_archivados, :conditions => "not archivado"
  
  def archive
    self.update_attributes({:archivado => true})
  end 

  def restore
    self.update_attributes({:archivado => false})    
  end

end
