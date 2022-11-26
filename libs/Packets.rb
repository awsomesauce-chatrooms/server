class PacketParser
  def initialize(packet)
      @packet = IO::Buffer.for(packet)
      @id = 0
  end

  def readByte()
      val = @packet.get_value(:U8, @id)
      @id += 1
      return val
  end

  def readString()
      string = @packet.get_string(@id, 128)
      @id += 128
      return string.strip!
  end

  def destroy()
    @packet.free
  end
end

class PacketWrite
  def initialize(size = 300)
    @packet = IO::Buffer.new(size)
    @id = 0
  end

  def writeByte(value)
    @packet.set_value(:U8, @id, value)
    @id += 1
    return self
  end

  def writeString(value)
    @packet.set_string(value+(" "*(128-value.length)), @id)
    @id += 128
    return self
  end

  def extract()
    sliced = @packet.slice(0, @id).get_string
    @packet.free
    return sliced
  end
end
