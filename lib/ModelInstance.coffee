uuid = require 'node-uuid'

class ModelInstance

  constructor: (@model,@item) ->
    @paused = true
    @queued_actions = []
    @setAttributes()
    @

  setAttributes: =>
    @id = uuid.v1()
    for attribute of @model.schema.attributes
      if @item
        @[attribute] = @item[attribute]
      else
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
 
  save: (cb) =>
    attributes = {}
    attributes.id = @id
    for attribute of @model.schema.attributes
      attributes[attribute] = @[attribute]
    if @paused
      @queued_actions.push =>
        console.log 'Dynasaur: '.yellow, 'Saving '+@model.name
        @model.table.put(attributes).save cb    
    else
      console.log 'Dynasaur: '.yellow, 'Saving '+@model.name
      @model.table.put(attributes).save cb

  update: (cb) =>
    attrs = []
    for attr of @model.schema.attributes
      attrs[attr] = @[attr]
    attrs.id = @id
    @model.table.put(attrs).save (err,data) =>
      console.log err
      cb null, @

  remove: (cb) =>
    @item.destroy (err) ->
      console.log 'DESTROYED'
      cb err

module.exports = ModelInstance

### 
old update function broken due to incomplete implementation of dynamo api
  update: (cb) =>
    #test for item prescence to prevent update on new model
    altered_attributes = []
    for attribute of @model.schema.attributes
      if @[attribute] isnt @item[attribute]
        altered_attributes.push attribute
    self = @
    console.log @item
    @item.update ->
      for altered_attribute in altered_attributes
        @put altered_attribute, self[altered_attribute]
    delete @item.Key
    delete @item.TableName
    @model.table.put(@item).save =>
      cb null, @
###

