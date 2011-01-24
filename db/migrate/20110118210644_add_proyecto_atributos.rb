class AddProyectoAtributos < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :codigo, :string
    add_column :proyectos, :estimacion, :integer
  end

  def self.down
    remove_column :proyectos, :codigo
    remove_column :proyectos, :estimacion
  end
end
