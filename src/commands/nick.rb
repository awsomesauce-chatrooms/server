def nick(command, client, args, server)
  if args.length == 1
    username = args[0]

    if username.length >= 15
      client.chat("> Username max length is 15.")
      return true
    end

    if client.username.start_with?("@")
      username = "@"+username
    else
      if username.start_with?("@")
        client.chat("> A username cannot start with @")
        return true
      end
    end

    if username.start_with?(">")
      client.chat("> A username cannot start with >")
      return true
    end

    for c in @server.clients
      if c.player.username == username
        client.chat("> This username is already being used!")
        return true
      end
    end

    for k in @server.db.all
      s = @server.db.get(k)
      if s == username
        client.chat("> Username already registered!")
        return true
      end
    end

    client.changeUsername(username)
  elsif args.length > 1
    client.chat("> There can be no spaces in nicknames.")
  elsif args.length < 1
    client.chat("> There has to be at least one argument.")
  end
end
