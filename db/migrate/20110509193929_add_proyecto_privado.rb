class AddProyectoPrivado < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :privado, :boolean
  end

  def self.down
    remove_column :proyectos, :privado
  end
end
