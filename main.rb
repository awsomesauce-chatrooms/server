require "./src/Server.rb"
require 'optparse'

@port = 8080

OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-l", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-p", "--port PORT", "Set a PORT for the network") do |v|
    @port = v
  end
end.parse!

Server.new(@port)
