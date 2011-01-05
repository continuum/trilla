class CreateProyectos < ActiveRecord::Migration
  def self.up
    create_table :proyectos do |t|
      t.string :descripcion
      t.references :cliente

      t.timestamps
    end
  end

  def self.down
    drop_table :proyectos
  end
end
