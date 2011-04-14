class AddTemporizadorEstado < ActiveRecord::Migration
  def self.up
    add_column :temporizadors, :estado, :string
  end

  def self.down
    remove_column :temporizadors, :estado
  end
end
