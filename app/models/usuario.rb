class Usuario < ActiveRecord::Base
  has_many :proyecto_usuarios
  has_many :proyectos, :through => :proyecto_usuarios

  validates_presence_of :nombres, :message => "Debe ingresar el nombre del usuario"
  validates_presence_of :email, :message => "Debe ingresar el e-mail del usuario"
  validates_presence_of :perfil, :message => "Debe ingresar un perfil"
  #TODO Cuando se definan estándar de perfiles, cambiar esta validación
  validates_inclusion_of :perfil, :in => %w( ADMIN USUARIO ), :if => :perfil?, :message => "Perfil inválido. Valores válidos son: ADMIN, USUARIO"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => :email?, :message => 'Formato de e-mail inválido'
  validates_uniqueness_of :email, :message => "Ya existe un usuario con esta dirección de e-mail"
  
  def self.find_by_login(login)
    find(:first, :conditions => ["rut = ?",login])
  end

  def self.autenticar(login, password)
    find(:first, :conditions => ["rut = ? and password = ?",login, password])
  end  
end
