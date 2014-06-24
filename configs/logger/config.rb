require 'logger'

module LoggerConfig

    def self.initialize
        #Read Configuration file
        log_file = RestMCOConfig.get_config['logger']['LOG_FILE']
        log_level = RestMCOConfig.get_config['logger][LOG_LEVEL']

        #Create log file if does not exists
        FileUtils.touch log_file
        #FileUtils.chown('nobody', 'nobody', log_file)
        #FileUtils.chmod(0666, log_file)

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

    def self.extract
        @@restmco_log
    end

end

$global_procs << { 'module' => 'LoggerConfig',
  'initialize' => 'LoggerConfig.initialize',
  'extract' => 'LoggerConfig.extract' }

