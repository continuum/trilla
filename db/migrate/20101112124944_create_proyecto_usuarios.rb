class CreateProyectoUsuarios < ActiveRecord::Migration
  def self.up
    create_table :proyecto_usuarios do |t|
      t.references :proyecto
      t.references :usuario

      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto_usuarios
  end
end
