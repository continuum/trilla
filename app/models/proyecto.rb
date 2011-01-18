class Proyecto < ActiveRecord::Base
  belongs_to :cliente
  named_scope :no_archivados, :conditions => "not archivado"
end
