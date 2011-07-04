class CreateProyectoContactos < ActiveRecord::Migration
  def self.up
    create_table :proyecto_contactos do |t|
      t.references :contacto
      t.references :proyecto

      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto_contactos
  end
end
