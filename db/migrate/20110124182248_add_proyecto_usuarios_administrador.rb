class AddProyectoUsuariosAdministrador < ActiveRecord::Migration
  def self.up
    add_column :proyecto_usuarios, :administrador, :boolean
  end

  def self.down
    remove_column :proyecto_usuarios, :administrador
  end
end
