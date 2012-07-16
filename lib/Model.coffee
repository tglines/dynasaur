ModelInstance = require './ModelInstance'

class Model

  constructor: (@name, @schema) ->
    @paused = true
    @instances = []
    @queued_actions = []
    @

  setTable: (table) =>
    @table = table
    @paused = false
    @unpause()
    @unpauseInstances()
  
  unpause: ->
    @paused = false
    for action in @queued_actions
      action()

  unpauseInstances: ->
    for instance in @instances
      instance.unpause()

  new: =>
    instance = new ModelInstance @, null
    @instances.push instance
    instance

  find: (query,cb) =>
    if @paused
      @queued_actions.push =>
        @table.scan(query).fetch (err,results) =>
          results_models = []
          for result in results
            result = @setItemAttrs item, result
            results_models.push new ModelInstance(@,result) 
          cb err, results_models
    else
      @table.scan(query).fetch (err,results) =>
        results_models = []
        for result in results
          results_models.push new ModelInstance(@,result) 
        cb err, results_models

  get: (itemKey,cb) =>
    if @paused
      @queued_actions.push =>
        item = @table.get(itemKey)
        item.fetch (err,result) =>
          result = @setItemAttrs item, result
          cb err, new ModelInstance(@,item)
    else
      item = @table.get(itemKey)
      item.fetch (err,result) =>
        result = @setItemAttrs item, result
        cb err, new ModelInstance(@,item)

  setItemAttrs: (item, result) ->
    for attr of result
      item[attr] = result[attr]
    item

module.exports = Model
