class CreateTareas < ActiveRecord::Migration
  def self.up
    create_table :tareas do |t|
      t.string :descripcion
      t.string :tipo
      t.timestamps
    end
  end

  def self.down
    drop_table :tareas
  end
end
