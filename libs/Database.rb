## This file has a very generic structure!!
## You can reimplement it to use SQLITE or anything else!!
## Please publish a pull request and issue if you wanna implement something else! :)

class Database
  def initialize(domain)
    unless Dir.exist?("databases")
      Dir.mkdir("databases")
    end

    unless Dir.exist?("databases/database_#{domain}")
      Dir.mkdir("databases/database_#{domain}")
    end

    @lmdb_env = LMDB.new("databases/database_#{domain}")
    @lmdb = @lmdb_env.database
  end

  def set(key, value)
    @lmdb[key] = value
  end

  def get(key)
    return @lmdb[key]
  end

  def all() # returns a array of all keys
    return @lmdb.keys
  end

  def has(key)
    return !get(key).nil?
  end
end
