class EliminaRut < ActiveRecord::Migration
  def self.up
    remove_column :usuarios, :rut
  end

  def self.down
    add_column :usuarios, :rut, :string
  end
end