class CreateTemporizadors < ActiveRecord::Migration
  def self.up
    create_table :temporizadors do |t|
      t.string :descripcion
      t.integer :iniciado
      t.timestamp :start
      t.timestamp :stop
      t.references :proyecto
      t.references :tarea
      t.references :usuario
#t.references :proyecto_tarea
#      t.references :proyecto_usuario
      t.timestamps
    end
  end

  def self.down
    drop_table :temporizadors
  end
end
