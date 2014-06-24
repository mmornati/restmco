#Load all helpers. Useful to install/add plugins
#
Dir.glob(File.join(File.dirname(__FILE__), "*.rb")).each do |file|
    next if __FILE__ == file
    require file
end
