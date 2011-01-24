class Usuario < ActiveRecord::Base
  has_many :proyecto_usuarios
  has_many :proyectos, :through => :proyecto_usuarios

  def self.find_by_login(login)
    find(:first, :conditions => ["rut = ?",login])
  end
  
  def self.autenticar(login, password)
    find(:first, :conditions => ["rut = ? and password = ?",login, password])
  end

end
