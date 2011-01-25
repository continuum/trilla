class AddClientesFonoContacto < ActiveRecord::Migration
  def self.up
    add_column :clientes, :fono, :string
    add_column :clientes, :contacto, :string
  end

  def self.down
    remove_column :clientes, :fono
    add_column :clientes, :contacto
  end
end
