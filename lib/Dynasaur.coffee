dynamo = require 'dynamo'
Model = require './model'

class Dynasaur
  models: {}
  model_instances: []

  constructor: (@aws_settings) ->
    dynamo_client = dynamo.createClient @aws_settings.credentials
    @dynamo_db = dynamo_client.get @aws_settings.region

  model: (name,schema) ->
    model_type = new Model name, schema
    @models[name] = model_type
    table = @dynamo_db.get name
    # try and grab the table
    table.fetch (err,table) =>
      if err
        #we need to make the table
        dynamo_schema = {}
        console.log 'LOGGING EACH INDEX IN SCHEMA'
        for index_type in schema.index
          console.log index_type
        console.log 'DONE'
        @dynamo_db.add(name,schema).save (err,table) ->
          table.watch (err,table) ->
            console.log 'Table created -> successfully retrieved'
            model_type.setTable table
      else
        console.log 'Table exists -> successfully retrieved'
        model_type.setTable table
    model_type


  #Check table to see if config is already set or changed
  #If not set do initial setup
  #Otherwise if old version alter config and tables to meet new version and up version of config
  #Else if current you're all set to continue

  #Periodically backup to s3 and upon backup up resource needs then take back down resource needs

module.exports = Dynasaur
