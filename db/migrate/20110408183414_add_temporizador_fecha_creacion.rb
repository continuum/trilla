class AddTemporizadorFechaCreacion < ActiveRecord::Migration
  def self.up
    add_column :temporizadors, :fecha_creacion, :datetime    
  end

  def self.down
    remove_column :temporizadors, :fecha_creacion
  end
end
