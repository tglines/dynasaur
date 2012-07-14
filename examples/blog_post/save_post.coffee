aws_settings = {
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  },
  region:'us-west-1'
}

Dynasaur = require '../../lib/Dynasaur'
dynasaur = new Dynasaur aws_settings

BlogPost = require('./models/BlogPost')(dynasaur)

blog_post = BlogPost.new()
blog_post.title = 'Dynasaur'
blog_post.author = 'Someone'
blog_post.body = 'Dynasaur is a DynamoDB ORM that builds some neat features on top of DynamoDB like S3 backups, Elastic Map Reduce and Multi-indexing'
blog_post.date = new Date()
blog_post.save (err,data) ->
  console.log err
