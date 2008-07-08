module Webistrano
  class ConfigurationFileCreator
    
    roles.each do |role|
      filename = eval(%{"#{file_target}"})
      tmpfile = "#{RAILS_ROOT}/tmp/files/#{File.dirname(filename)}"
      FileUtils.mkdir_p tmpfile
      tmpfile = tmpfile + '/' + File.basename(filename)
      File.open(tmpfile, 'w') do |f|
        f.puts tpl.result(binding)
      end
      %x(scp #{tmpfile} deploy@#{role.server.ip}:#{filename})
    end
  end
end