require 'inifile'
require 'logger'

module RestMCOConfig


    @ini = nil

    def self.load_config(config_file)
        @ini=IniFile.load(config_file, :comment => '#')
    end

    def self.initialize_log
        #Read Configuration file
        log_file = @ini['logger']['LOG_FILE']
        log_level = @ini['logger][LOG_LEVEL']
        
        #Create log file if does not exists
        FileUtils.touch log_file
        FileUtils.chown('nobody', 'nobody', log_file)
        
        #Create Log file
        @@restmco_log = Logger.new(log_file)
        
        case log_level
            when 'DEBUG'
                restmco_log.level = Logger::DEBUG
            when 'INFO'
                restmco_log.level = Logger::INFO
            when 'WARN'
                restmco_log.level = Logger::WARN
            when 'ERROR'
                restmco_log.level = Logger::ERROR
        end
    end


    def self.restmco_log
        @@restmco_log
    end

end
