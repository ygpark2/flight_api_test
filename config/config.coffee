path     = require 'path'
rootPath = path.normalize __dirname + '/..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'flight-express'
    port: 3000
    db: 'sqlite://localhost/flight-express-development'
    storage: rootPath + '/data/flight-express-development'

  test:
    root: rootPath
    app:
      name: 'flight-express'
    port: 3000
    db: 'sqlite://localhost/flight-express-test'
    storage: rootPath + '/data/flight-express-test'

  production:
    root: rootPath
    app:
      name: 'flight-express'
    port: 3000
    db: 'sqlite://localhost/flight-express-production'
    storage: rootPath + '/data/flight-express-production'

module.exports = config[env]
