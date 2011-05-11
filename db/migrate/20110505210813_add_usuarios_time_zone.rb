class AddUsuariosTimeZone < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :time_zone, :string
  end

  def self.down
    remove_column :usuarios, :time_zone
  end
end
