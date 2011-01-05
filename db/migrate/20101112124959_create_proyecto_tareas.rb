class CreateProyectoTareas < ActiveRecord::Migration
  def self.up
    create_table :proyecto_tareas do |t|
      t.references :proyecto
      t.references :tarea

      t.timestamps
    end
  end

  def self.down
    drop_table :proyecto_tareas
  end
end
