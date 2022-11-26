require 'securerandom'

class Player
  attr_accessor :username, :token, :client

  def initialize(client)
    @client = client
    @server = @client.server

    @username = rand(696969).to_s
    @token = ""
  end

  def changeUsername(name)
    @server.broadcast((PacketWrite.new).writeByte(0x04).writeString(@username).writeString(name))
    @username = name
  end

  def chat(string)
    @client.write((PacketWrite.new).writeByte(0x01).writeString(string))
  end

  def connected(token)
    for m in @server.config["motd"]
      chat("> " + m)
    end

    @token = token

    if @token != "" and @server.db.has(@token)
      @username = @server.db.get(@token)
    else
      if @server.db.has(@client.ip)
        @token = @server.db.get(@client.ip)
        @username = @server.db.get(@token)
      else
        @token = SecureRandom.uuid

        @server.db.set(@token, @username)
        @server.db.set(@client.ip, @token)
      end
    end

    @client.write((PacketWrite.new).writeByte(0x00).writeString(@token))

    for c in @server.clients
      if c.player.username == @username and c.socket != @client.socket
        chat("> This username is already being used!")
        return true
      end
    end

    @server.broadcast((PacketWrite.new).writeByte(0x02).writeString(@username))

    puts "!! Sucesfully authenicated user #{@username} under IP #{@client.ip} with token #{@token}"

    for c in @server.clients
      if c.socket != @client.socket
        write((PacketWrite.new).writeByte(0x02).writeString(c.player.username))
      end
    end

    for c in @server.history
      chat(c)
    end
  end

  def message(message)
    pack = (PacketWrite.new).writeByte(0x01).writeString("#{@username}: #{message}")

    if !@server.commands.parse(message, self)
      @server.broadcast(pack)
      @server.history.append("#{@username}: #{message}")
      @server.history = @server.history.last(5)
    end
  end
end
