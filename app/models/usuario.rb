class Usuario < ActiveRecord::Base
  has_many :proyecto_usuarios
  has_many :proyectos, :through => :proyecto_usuarios

  validates_presence_of :nombres, :message => "Se debe ingresar el nombre del usuario"
  validates_presence_of :email, :message => "Se debe ingresar el e-mail del usuario"
  validates_uniqueness_of :email, :message => "Ya existe un usuario con este correo"
  validates_format_of     :email,
                          :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                          :message    => 'Formato de correo inválido'
  def self.find_by_login(login)
    find(:first, :conditions => ["rut = ?",login])
  end
  
  def self.autenticar(login, password)
    find(:first, :conditions => ["rut = ? and password = ?",login, password])
  end

end
