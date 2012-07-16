dynamo = require 'dynamo'
colors = require 'colors'
Model = require './model'

class Dynasaur
  models: {}
  model_instances: []

  constructor: (@aws_credentials, @project_name) ->
    console.log 'Dynasaur: '.yellow, 'Welcome to Dynasaur, connecting to DynamoDB'
    @paused = true
    @queued_actions = []
    @schemas = []
    dynamo_client = dynamo.createClient @aws_credentials
    @dynamo_db = dynamo_client.get 'us-west-1'
    @checkForProjectConfig()

  checkForProjectConfig: ->
    console.log 'Dynasaur: '.yellow, 'Checking to see if config present'
    config_table_name = "#{@project_name}_config"
    table = @dynamo_db.get config_table_name
    table.fetch (err, table)  =>
      if err
        console.log 'Dynasaur: '.yellow, 'Initializing indexed table for the first time ...'
        config_schema = {name: config_table_name, model_type: String}
        @dynamo_db.add(config_table_name,config_schema).save (err, table) =>
          console.log 'Dynasaur: '.yellow, 'Config table not found but has been made'
          @unpause()
      else
        console.log 'Dynasaur: '.yellow, 'Recognized database, checking if all indexed tables are current ...'
        for schema in @schemas
          @checkIndicies table, schema
        @unpause()

  checkIndicies: (table, schema) ->
    console.log 'Dynasaur: '.yellow, 'Checking '+schema.name+' Indicies'

  unpause: =>
    @paused = false
    for action in @queued_actions
      action()    

  model: (name,schema) ->
    @schemas.push {name:name, schema:schema}
    model_type = new Model name, schema
    @models[name] = model_type
    table = @dynamo_db.get name
    # try and grab the table
    if @paused
      @queued_actions.push =>
        table.fetch (err,table) =>
          if err
            #we need to make the table
            @dynamo_db.add(name,schema).save (err,table) ->
              table.watch (err,table) ->
                console.log 'Dynasaur: '.yellow, 'Created '+model_type.model.name + ' table' 
                model_type.setTable table
          else
            model_type.setTable table
    else
      table.fetch (err,table) =>
        if err
          #we need to make the table
          @dynamo_db.add(name,schema).save (err,table) ->
            table.watch (err,table) ->
              model_type.setTable table
        else
          model_type.setTable table
    model_type

module.exports = Dynasaur
