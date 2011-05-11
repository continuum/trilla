class SetDefaultValuesUsuariosTimeZone < ActiveRecord::Migration
  def self.up
    Usuario.find(:all).each do |u|
      u.update_attribute :time_zone, "Santiago"
    end
  end

  def self.down
  end
end
