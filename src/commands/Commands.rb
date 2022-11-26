require "./src/commands/nick.rb"
require "./src/commands/gainop.rb"

class Commands
  def initialize(server)
    @server = server
  end

  def parse(string, client)
    if string.start_with?("/")
      args = string.delete_prefix('/').split(" ")
      command = args.shift

      if command == "nick"
        nick(command, client, args, @server)
      end
      if command == "gainop"
        gainop(command, client, args, @server)
      end
      return true
    end
  end
end
