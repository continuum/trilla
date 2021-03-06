class Usuario < ActiveRecord::Base
  has_many :proyecto_usuarios
  has_many :temporizadors
  has_many :proyectos, :through => :proyecto_usuarios 

  validates_presence_of :nombres, :message => "Debe ingresar el nombre del usuario"
  validates_presence_of :email, :message => "Debe ingresar el e-mail del usuario"
  validates_presence_of :perfil, :message => "Debe ingresar un perfil"
  #TODO Cuando se definan estándar de perfiles, cambiar esta validación
  validates_inclusion_of :perfil, :in => %w( ADMIN USUARIO ), :if => :perfil?, :message => "Perfil inválido. Valores válidos son: ADMIN, USUARIO"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => :email?, :message => 'Formato de e-mail inválido'
  validates_uniqueness_of :email, :message => "Ya existe un usuario con esta dirección de e-mail",:on => :create
  
  def self.find_by_login(login)
    find(:first, :conditions => ["rut = ?",login])
  end

  def self.autenticar(login, password)
    find(:first, :conditions => ["rut = ? and password = ?",login, password])
  end
  
  def admin?
    self.perfil == "ADMIN"
  end
  
  def before_destroy
    if self.proyectos.count > 0
      errors.add_to_base "El usuario se encuentra en proyectos"
      false
    end
    if self.temporizadors.count > 0
      errors.add_to_base "El usuario tiene reportes de horas creados"
      false
    end
    
  end
  
  def enable_api!
    self.generate_api_key!
  end

  def disable_api!
    self.update_attribute(:api_key, "")
  end

  def api_is_enabled?
    !self.api_key.empty?
  end

  protected

    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def generate_api_key!
      self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
    end
      
  
end
