module McollectiveConfig

    def self.initialize
        @@mcollective_config = {
            'MCO_CONFIG'      => RestMCOConfig.get_config['mcollective']['MCO_CONFIG'], #|| '/etc/mcollective/client.cfg',
            'MCO_TIMEOUT'     => RestMCOConfig.get_config['mcollective']['MCO_TIMEOUT'].to_i, # || 10, 
            'MCO_DISCOVTMOUT' => RestMCOConfig.get_config['mcollective']['MCO_DISCOVTMOUT'].to_i, # || 4,
            'MCO_DEBUG'       => RestMCOConfig.get_config['mcollective']['MCO_DEBUG'], # || false,
            'MCO_COLLECTIVE'  => RestMCOConfig.get_config['mcollective']['MCO_COLLECTIVE'], #|| nil,
        }
    end

    def self.extract
        @@mcollective_config
    end

end

$global_procs << { 'module' => 'McollectiveConfig',
  'initialize' => 'McollectiveConfig.initialize',
  'extract' => 'McollectiveConfig.extract' }

