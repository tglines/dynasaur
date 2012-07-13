uuid = require 'node-uuid'

class ModelInstance

  constructor: (@model) ->
    @paused = true
    @queued_actions = []
    @setAttributes()
    @

  setAttributes: ->
    @id = uuid.v1()
    for attribute of @model.schema.attributes
      if(typeof attribute is 'string')
        @[attribute] = ''
      else if (typeof attribute is 'number')
        @[attribute] = 0

  unpause: ->
    @paused = false
    for action in @queued_actions
      action()

  dump: ->
    console.log @
 
  save: (cb) ->
    attributes = {}
    attributes.id = @id
    for attribute of @model.schema.attributes
      attributes[attribute] = @[attribute]
    if @paused
      @queued_actions.push =>
        @model.table.put(attributes).save cb    
    else
      @model.table.put(attributes).save cb    

module.exports = ModelInstance
