require_relative 'loadini' if RUBY_VERSION >= "1.9"
require File.join(File.dirname(__FILE__), 'loadini') if RUBY_VERSION < "1.9"

module RestMCOConfig
    
    def self.load_config(config_file)
        LoadIni.load_config(config_file)
    end

    def self.get_config()
        LoadIni.get_config
    end

    #This variable will be filled up by any config found
    $global_procs = []

    def self.initialize_all
        Dir.glob(File.join(File.dirname(__FILE__), "**", "config.rb")).each do |file|
          next if __FILE__ == file
          next if File.directory?(file)  
          require file
        end

        @@config_map = Hash.new
        $global_procs.each { |p|
          puts "Configuring module: " + p['module']
          eval(p['initialize']+ '()')
          mod_config = eval(p['extract']+'()')
          next unless mod_config.instance_of?(Hash)
          @@config_map.merge!(mod_config)
        }
    end

    def self.get
        @@config_map
    end


    def self.logger
        include LoggerConfig
        LoggerConfig.extract
    end
end
