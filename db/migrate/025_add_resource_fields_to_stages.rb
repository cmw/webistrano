class AddResourceFieldsToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :memory_need, :integer
    add_column :stages, :instances, :integer
  end

  def self.down
    remove_column :stages, :memory_need
    remove_column :stages, :instances
  end
end
