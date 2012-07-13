dynasaur
========

A DynamoDB ORM for Node.js

It aims to provide a few added features that most people will want from a DynamoDB tool.  These things include a Mongoose inspired way of doing things, periodic S3 backups, multi-indexing (clones data to seperate tables, having different indexes on each) and more.

For now it provides a simple way to interact with DynamoDB and create/read rows in the table.  More features coming.

For Example, here I save a blog post:

`
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
`


