class Tarea < ActiveRecord::Base

  def self.find_order
    find(:all, :order => "tipo" )
  end
  
  def self.find_facturables
    find(:all, :conditions => ["tipo = 'Facturable'"] )
  end
  
  def self.find_no_facturables
    find(:all, :conditions => ["tipo = 'No Facturable'"] )
  end

end

class TareaOrder
  
  attr_accessor :descripcion
  
  
end
