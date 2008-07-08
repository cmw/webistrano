class CreateConfigurationFiles < ActiveRecord::Migration
  def self.up
    create_table :configuration_files do |t|
      t.string :name
      t.string :file_target
      t.text :file_template

      t.timestamps
    end
  end

  def self.down
    drop_table :configuration_files
  end
end
