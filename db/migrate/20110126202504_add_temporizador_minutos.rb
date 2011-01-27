class AddTemporizadorMinutos < ActiveRecord::Migration
  def self.up
    add_column :temporizadors, :minutos, :integer    
  end

  def self.down
    remove_column :temporizadors, :minutos
  end
end
