require "./src/Player.rb"

class Client
  attr_accessor :player, :socket, :server, :ip

  def write(writer, raw = false)
    if raw
      packet = writer
    else
      packet = writer.extract()
    end

    begin
      @socket.send(packet, 0)
    rescue
      puts "connection broke while send. failed writing ID#{zz[0].ord}"
    end
  end

  def initialize(socket, server)
    @socket = socket
    @server = server
    @ip = @socket.peeraddr.last();
    @player = Player.new(self)
  end

  def start()
    loop do
      begin
        readID = @socket.recv(1)
      rescue
        puts "connection broke while recv"
        break
      end

      if !readID.empty?
        packetID = readID.ord;

        length = $dataLengths[packetID]

        unless length
            puts "#{packetID} unknown"
            break
        end

        packet = ""

        packet = @socket.recv(length)
        parser = PacketParser.new(packet)

        unless packet
            puts "packet read attempt failed"
            break
        end

        if packetID == 0
          @player.connected(parser.readString())
        end

        if packetID == 1
          @player.message(parser.readString())
        end

        parser.destroy
      else
        puts "closed"
        break
      end
    end
  end
end
