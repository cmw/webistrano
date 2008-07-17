class MoveRolesIntoConfigurationFile < ActiveRecord::Migration
  def self.up
    add_column :configuration_files, :roles, :string
    
    drop_table :configuration_files_roles
  end

  def self.down
    remove_column :configuration_files, :roles
    
    create_table "configuration_files_roles", :id => false, :force => true do |t|
      t.integer "configuration_file_id", :limit => 11, :null => false
      t.integer "role_id",               :limit => 11, :null => false
    end
  end
end
