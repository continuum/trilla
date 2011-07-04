class Cliente < ActiveRecord::Base
  has_many :proyectos
  has_many :proyecto_usuarios, :through => :proyectos
  has_many :contactos
  
  validates_presence_of :descripcion, :message => "Debe ingresar un nombre para el cliente"
  
  def before_destroy
    if Cliente.cantidad_proyectos(self.id) > 0
      errors.add_to_base "El cliente posee proyectos asociados"
      false
    end
  end
  
  def self.cantidad_proyectos(cliente_id)
    Proyecto.count :conditions =>["cliente_id = ?", cliente_id]
  end
  
  def self.find_with_proyectos_by_usuario(usuario_id)
    find(
      :all,
      :include => [:proyectos => :proyecto_usuarios],
      :conditions => ["(proyecto_usuarios.usuario_id = ? or proyectos.privado = ?) and proyectos.archivado = ?", usuario_id, false, false]
    )
  end
  
end