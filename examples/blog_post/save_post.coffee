aws_credentials = {accessKeyId:'your_aws_key', secretAccessKey:'your_aws_secret'}

Dynasaur = require './lib/Dynasaur'
dynasaur = new Dynasaur aws_credentials

BlogPost = require('./models/BlogPost')(dynasaur)

blog_post = BlogPost.new()
blog_post.title = 'Dynasaur'
blog_post.author = 'Someone'
blog_post.body = 'Dynasaur is a DynamoDB ORM that builds some neat features on top of DynamoDB like S3 backups, Elastic Map Reduce and Multi-indexing'
blog_post.date = new Date()
blog_post.save (err,data) ->
  console.log err
