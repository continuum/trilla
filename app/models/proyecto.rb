class Proyecto < ActiveRecord::Base
  belongs_to :cliente
  named_scope :no_archivados, :conditions => "not archivado"
   
  def archive
    self.update_attributes({:archivado => true})
  end 

  def restore
    self.update_attributes({:archivado => false})    
  end

end
