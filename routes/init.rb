#Include all routes modules files

Dir.glob(File.join(File.dirname(__FILE__), "**", "init.rb")).each do |file|
    next if __FILE__ == file
    require file
end
