class AddResourceFieldsToHosts < ActiveRecord::Migration
  def self.up
    add_column :hosts, :memory, :integer
  end

  def self.down
    remove_column :hosts, :memory
  end
end
