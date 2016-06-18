express = require 'express'
router = express.Router()
rest = require 'rest'
mime = require 'rest/interceptor/mime'
retry = require 'rest/interceptor/retry'
timeout = require 'rest/interceptor/timeout'

querystring = require 'querystring'

db = require '../../models'
util = require 'util'
moment = require 'moment'
_ = require 'lodash'

api_url = "http://node.locomote.com/code-task/"

client = rest.wrap(mime).wrap(retry, { initial: 1e3, max: 3e3 }).wrap(timeout, { timeout: 10e3 })

module.exports = (app) ->
  app.use '/api', router

router.get '/airlines', (req, res) ->
  client({ path: api_url + 'airlines' }).then (response) ->
    if response.status.code == 200
      res.send response.entity
    else
      res.send []

router.get '/airports', (req, res) ->
  q = req.query.q
  console.log q
  client({ path: api_url + "airports?q=" + q }).then (response) ->
    if response.status.code == 200
      res.send response.entity
    else
      res.send []

router.post '/search', (req, res) ->
  params = {
    "from" : req.body.fromLocation.toUpperCase()
    "to" : req.body.toLocation.toUpperCase()
    "date" : req.body.travelDate
  }

  dateRange = []
  startDate = moment(req.body.travelDate).subtract(2, 'days')
  for cnt in [0..4] # get +- 2 days from selected date
    dateRange.push startDate.format 'YYYY-MM-DD'
    startDate.add(1, 'days')

  searchApi = (params) ->
    airlineCode = params.airlineCode
    delete params.airlineCode
    url = api_url + "flight_search/" + airlineCode + "?" + querystring.stringify(params)
    return client({ path: url }).then(
      (response) ->
        # called if the response took less then 10 seconds
        return {date : "#{params.date}", value: response.entity}
      ,
      (response) ->
        # called if the response took greater then 10 seconds
        return {date: "#{params.date}", value: "error timeout !"}
    )

  client({ path: api_url + 'airlines' }).then (response) ->
    if response.status.code == 200
      return response.entity
    else
      return []
  .then (airlineData) ->
    return dateRange.map (dateString) ->
      paramList = []
      airlineData.forEach (airlineInfo, airlineIdx, airlineArray) ->
        cloneParams = _.cloneDeep params
        cloneParams.date = dateString
        cloneParams.airlineCode = airlineInfo.code
        paramList.push cloneParams
      return paramList
  .then (paramList) ->
    return Promise.all(_.flatten(paramList).map searchApi)
  .then (data) ->
    jsonData = _.chain(data).groupBy("date").map (value, key) ->
      vals = value.map (val) ->
        return val.value
      return { "#{key}" : _.flatten(vals) }
    res.json jsonData

  ###
  client.methods.airlinesApi (airlineData, response) ->
    if util.isArray airlineData
      airlineData.forEach (airlineInfo, airlineIdx, airlineArray) ->
        startDate = moment(req.body.travelDate).subtract(2, 'days')
        endDate = moment(req.body.travelDate).add(3, 'days')
        while startDate.isBefore(endDate)
          params.date = startDate.format 'YYYY-MM-DD'
          url = api_url + "flight_search/" + airlineInfo.code + "?" + querystring.stringify(params)
          console.log url
          client.get url, (flightData, response) ->
            if util.isArray flightData
              result[airlineInfo.code] = {"#{params.date}" : flightData}
              flightData.forEach (flightInfo, flightIdx, flightArray) ->
                console.log flightInfo
                console.log "-----------------------------------------------------------"
            else
              result[airlineInfo.code] = {"#{params.date}" : flightData.toString 'utf8'}
              console.log flightData.toString 'utf8'
              console.log result
          startDate.add(1, 'days')
    console.log result
  ###
  # res.send {}

