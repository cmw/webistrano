class ConfigurationFile < ActiveRecord::Base
  attr_accessible :name, :file_target, :file_template, :before_task, :after_task, :roles
  
  validates_presence_of :name
  validates_presence_of :roles
  validates_presence_of :file_template
  validates_presence_of :file_target
  
  def rendered_content(role)
    ERB.new(file_template).result(role.get_binding)
  end
end
