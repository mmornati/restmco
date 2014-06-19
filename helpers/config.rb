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


    def self.initialize_mcollective
        @@mcollective_config = {
            #"MCO_CONFIG"      => @ini['mcollective'][MCO_CONFIG] unless @ini['mcollective'][MCO_CONFIG]).nil?, #|| '/etc/mcollective/client.cfg',
            #"MCO_TIMEOUT"     => @ini['mcollective'][MCO_TIMEOUT] unless @ini['mcollective'][MCO_TIMEOUT]).nil, # || 10, 
            #"MCO_DISCOVTMOUT" => @ini['mcollective'][MCO_DISCOVTMOUT] unless @ini['mcollective'][MCO_DISCOVTMOUT].nil?, # || 4,
            #"MCO_DEBUG"       => @ini['mcollective'][MCO_DEBUG] unless @ini['mcollective'][MCO_DEBUG].nill?, # || false,
            #"MCO_COLLECTIVE"  => @ini['mcollective'][MCO_COLLECTIVE] unless @ini['mcollective'][MCO_COLLECTIVE].nil?, #|| nil,
            "MCO_CONFIG"      => '/etc/mcollective/client.cfg',
            "MCO_TIMEOUT"     => 10,
            "MCO_DISCOVTMOUT" => 4,
            "MCO_DEBUG"       => false,
            "MCO_COLLECTIVE"  => nil

        }
    end

    def self.initialize_all
        self.initialize_mcollective
        self.initialize_log
    end


    def self.restmco_log
        @@restmco_log
    end

    def self.get_mco_config
        @@mcollective_config
    end

end
