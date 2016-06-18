express  = require 'express'
router = express.Router()
db = require '../models'

module.exports = (app) ->
  app.use '/', router

router.get '/', (req, res) ->
  db.Article.findAll().then (articles) ->
    res.render 'index',
      title: 'Locomote Flight Code Test'
      articles: articles

