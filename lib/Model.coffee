ModelInstance = require './ModelInstance'

class Model

  constructor: (@name, @schema) ->
    @instances = []
    @

  setTable: (table) =>
    console.log table
    @table = table
    @unpauseInstances()
  
  unpauseInstances: ->
    for instance in @instances
      instance.unpause()

  new: =>
    instance = new ModelInstance @
    @instances.push instance
    instance

module.exports = Model
