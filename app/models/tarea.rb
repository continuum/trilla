class Tarea < ActiveRecord::Base
  named_scope :facturables, :conditions => "tipo = 'Facturable'"
  named_scope :no_facturables, :conditions => "tipo = 'No Facturable'"
  named_scope :ordered_by_tipo, :order => "tipo"
end

class TareaOrder
  
  attr_accessor :descripcion
  
  
end
