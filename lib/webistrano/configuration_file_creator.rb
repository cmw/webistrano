module Webistrano
  class ConfigurationFileCreator
    attr_accessor :before_tasks, :after_tasks, :stage, :files
    
    def initialize(deployment)
      @stage = deployment.stage
      @files = {}
      @before_tasks, @after_tasks = [], []
      configure
    end

    def deploy_files
      @files.each do |source, target|
        %x(scp #{source} #{@stage.configuration_parameters.find_by_name('user')}@#{target})
      end
    end
    
  private
    def configure
      @stage.roles.each do |role|
        ConfigurationFile.find(:all, :conditions => {:roles => "%#{role}%"}).each do |config_file|
          filename = eval(%{"#{config_file.file_target}"})
          current_file = %x(ssh deploy@#{role.server.ip} cat #{filename})
          rendered_template = config_file.render_content(role.get_binding)
          unless current_file == rendered_template
            tmpfile = "#{RAILS_ROOT}/tmp/files/#{File.dirname(filename)}"
            FileUtils.mkdir_p tmpfile
            tmpfile = tmpfile + '/' + File.basename(filename)
            File.open(tmpfile, 'w') do |f|
              f.puts rendered_template
            end
            @files[tmpfile] = %(#{role.server.ip}:#{filename})
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
  
  Webistrano::Template::Base::TASKS += <<-'EOS'
    namespace :deploy do
      desc "Deploying the config files and running the before and after tasks."
      task :configuration_files do
        cfc = ConfigurationFileCreator.new(deployment)
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