class ConfigurationFile < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  attr_accessible :name, :file_target, :file_template, :before_task, :after_task
  def rendered_content
    ERB.new(file_template).result(binding)
  end
end
