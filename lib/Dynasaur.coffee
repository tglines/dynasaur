dynamo = require 'dynamo'
Model = require './model'

class Dynasaur
  models: {}
  model_instances: []

  constructor: (@aws_credentials) ->
    dynamo_client = dynamo.createClient @aws_credentials
    @dynamo_db = dynamo_client.get 'us-west-1'

  model: (name,schema) ->
    model_type = new Model name, schema
    @models[name] = model_type
    table = @dynamo_db.get name
    # try and grab the table
    table.fetch (err,table) =>
      if err
        #we need to make the table
        @dynamo_db.add(name,schema).save (err,table) ->
          table.watch (err,table) ->
            console.log 'Table created -> successfully retrieved'
            model_type.setTable table
      else
        console.log 'Table exists -> successfully retrieved'
        model_type.setTable table
    model_type

module.exports = Dynasaur
