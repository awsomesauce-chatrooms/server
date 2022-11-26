require 'socket'
require 'lmdb'
require 'json'
require "./libs/Packets.rb"
require "./libs/Database.rb"
require "./src/commands/Commands.rb"
require "./src/Client.rb"

$dataLengths = {0 => 128, 1 => 128, 2 => 128, 3 => 128, 4 => 257}

class Server
  attr_accessor :clients, :commands, :config, :db, :history

  def broadcast(pack, ignore = false)
    for c in @clients
      if c.player.username == ignore or c.socket == ignore; return; end

      c.write(pack)
    end
  end


  def initialize(port)
    @server = TCPServer.new port
    @commands = Commands.new self
    @clients = []
    @history = []

    unless Dir.exist?("config")
      Dir.mkdir("config")
    end

    unless File.exist?("config/settings.json")
      File.write("config/settings.json",
        <<~EOS
          {
            "motd": ["hello world motd"],
            "password": "testing"
          }
        EOS
      )
    end

    @config = JSON.parse(File.open("config/settings.json").read())
    @db = Database.new("server")

    loop do
        Thread.start(@server.accept) do |client|
            c = Client.new(client, self);
            @clients.append(c)

            if !c.start()
              broadcast((PacketWrite.new).writeByte(0x03).writeString(c.player.username), client)

              @db.set(c.player.token, c.player.username)
            end

            @clients.delete(c)
        end
    end

    @db.destroy
  end
end
