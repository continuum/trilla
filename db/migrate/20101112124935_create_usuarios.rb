class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.string :rut
      t.string :nombres
      t.string :email
      t.string :password
      t.string :perfil
      t.timestamps
    end
  end

  def self.down
    drop_table :usuarios
  end
end
