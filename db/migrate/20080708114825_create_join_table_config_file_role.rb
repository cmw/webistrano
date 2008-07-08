class CreateJoinTableConfigFileRole < ActiveRecord::Migration
  def self.up
    create_table :configuration_files_roles, :id => false do |t|
      t.integer :configuration_file_id, :null => false
      t.integer :role_id, :null => false
    end
  end

  def self.down
    drop_table :configuration_files_roles
  end
end
