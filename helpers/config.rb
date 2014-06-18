require 'inifile'
require 'logger'

module RestMCOConfig

    ini=IniFile.load('/etc/restmco/restmco.cfg', :comment => '#')

    #Read Configuration file
    LOG_FILE = ini['logger']['LOG_FILE']
    LOG_LEVEL = ini['logger][LOG_LEVEL']
    
    #Create log file if does not exists
    FileUtils.touch LOG_FILE
    FileUtils.chown('nobody', 'nobody', LOG_FILE)
    
    #Create Log file
    @@restmco_log = Logger.new(LOG_FILE)
    
    case LOG_LEVEL
        when 'DEBUG'
            restmco_log.level = Logger::DEBUG
        when 'INFO'
            restmco_log.level = Logger::INFO
        when 'WARN'
            restmco_log.level = Logger::WARN
        when 'ERROR'
            restmco_log.level = Logger::ERROR
    end

    def self.restmco_log
        @@restmco_log
    end
end
