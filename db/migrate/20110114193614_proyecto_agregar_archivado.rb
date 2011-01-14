class ProyectoAgregarArchivado < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :archivado, :boolean
  end

  def self.down
    remove_column :proyectos, :archivadoser
  end
end
