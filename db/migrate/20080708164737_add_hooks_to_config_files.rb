class AddHooksToConfigFiles < ActiveRecord::Migration
  def self.up
    add_column :configuration_files, :before_task, :string
    add_column :configuration_files, :after_task, :string
  end

  def self.down
    remove_column :configuration_files, :before_task
    remove_column :configuration_files, :after_task
  end
end
