require 'inifile'

module LoadIni

    @ini = nil

    def self.load_config(config_file)
        @ini=IniFile.load(config_file, :comment => '#')
    end

    def self.get_config
        @ini
    end
end
