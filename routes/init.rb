#Include all routes modules files

Dir.glob(File.join(".", "**", "init.rb")).each do |file|
    require file
end
