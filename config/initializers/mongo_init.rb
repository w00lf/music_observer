MongoMapper.connection = Mongo::Connection.new(MONGODB_HOST, MONGODB_PORT)
MongoMapper.connection.db(MONGODB_BASE).authenticate(MONGODB_USER, MONGODB_PASS)
MongoMapper.database = MONGODB_BASE
