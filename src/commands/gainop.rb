def gainop(command, client, args, server)
  if client.username.start_with?("@")
    client.changeUsername(client.username.delete_prefix('@'))
    client.chat("> You can regain your op by doing /gainop PASSWORD again.")
    return
  end

  if args.join(" ") == server.config["password"]
    client.changeUsername("@" + client.username)
    client.chat("> Welcome back " + client.username + "!")

  else
    client.chat("> Missing permissions.")
  end
end
