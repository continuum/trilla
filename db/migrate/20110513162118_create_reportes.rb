class CreateReportes < ActiveRecord::Migration
  def self.up
    create_table :reportes do |t|
      t.string :nombre
      t.string :descripcion
      t.string :tipo
      t.string :query
      t.timestamps
    end
  end

  def self.down
    drop_table :reportes
  end
end
