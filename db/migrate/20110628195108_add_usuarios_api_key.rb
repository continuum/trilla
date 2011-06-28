class AddUsuariosApiKey < ActiveRecord::Migration
  def self.up
      add_column :usuarios, :api_key, :string, :limit => 40, :default => ""
       execute "UPDATE Usuarios set api_key = ''"
  end

  def self.down
    remove_column :usuarios, :api_key
  end
end
 