module Webistrano
  class ConfigurationFileCreator
    attr_accessor :before_tasks, :after_tasks, :stage, :files
    
    def initialize(stage)
      @logger = RAILS_DEFAULT_LOGGER
      @stage = stage
      @files = {}
      @before_tasks, @after_tasks = [], []
      configure
    end

    def deploy_files
      @files.each do |source, target|
        %x(scp #{source} #{@stage.project.configuration_parameters.find_by_name('user').value}@#{target})
      end
    end
    
  private
    def configure
      FileUtils.rm_rf "#{RAILS_ROOT}/tmp/files"
      @stage.roles.each do |role|
        ::ConfigurationFile.find(:all, :conditions => ["roles like ?", "%#{role.name}%"]).each do |config_file|
          role.stage.project.configuration_parameters.each do |param|
            (class << role; self; end).send :attr_accessor, param.name.to_sym
            role.instance_variable_set(:"@#{param.name}", param.value)
          end
          filename = eval(%{"#{config_file.file_target}"}, role.get_binding)
          current_file = %x(ssh deploy@#{role.host.name} cat #{filename})
          rendered_template = config_file.rendered_content(role)
          unless current_file == rendered_template
            tmpfile = "#{RAILS_ROOT}/tmp/files/#{File.dirname(filename)}"
            FileUtils.mkdir_p tmpfile
            tmpfile = tmpfile + '/' + File.basename(filename)
            File.open(tmpfile, 'w') do |f|
              f.puts rendered_template
            end
            @files[tmpfile] = %(#{role.host.name}:#{filename})
            @after_tasks << config_file.after_task if config_file.after_task
            @before_tasks << config_file.before_task if config_file.before_task
          end
        end
      end
      @before_tasks.uniq!
      @before_tasks.map!{|task| task.gsub!(':', '.')}
      @after_tasks.uniq!
      @after_tasks.map!{|task| task.gsub!(':', '.')}
    end
  end
  
  module ConfigurationFileDeployment
    TASKS = <<-'EOS'
      namespace :deploy do
        desc "Deploying the config files and running the before and after tasks."
        task :configuration_files do
          stage = Project.find_by_name(fetch(:webistrano_project, "")).stages.find_by_name(fetch(:webistrano_stage, ""))
          cfc = Webistrano::ConfigurationFileCreator.new(stage)
          cfc.before_tasks.each do |task|
            eval(task)
          end
          cfc.deploy_files
          cfc.after_tasks.each do |task|
            eval(task)
          end
        end
      end
    EOS
  end
end