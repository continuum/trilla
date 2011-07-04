class Contacto < ActiveRecord::Base
  belongs_to :cliente
  
  validates_presence_of :nombre, :message => "Debe ingresar el nombre del contacto"
  validates_presence_of :email, :message => "Debe ingresar el correo del contacto"
  validates_presence_of :telefono, :message => "Debe ingresar el telefono del contacto"
  validates_numericality_of :cliente_id, :greater_than => 0, :message => "Debe seleccionar un cliente"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => :email?, :message => 'Formato de e-mail inválido'
  validates_uniqueness_of :email, :message => "Ya existe un contacto con esta dirección de e-mail",:on => :create
  
end
