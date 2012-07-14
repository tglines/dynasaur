dynasaur
========

A DynamoDB ORM for Node.js

It aims to provide a few added features that most people will want from a DynamoDB tool.  These things include a Mongoose inspired way of doing things, periodic S3 backups, multi-indexing (clones data to seperate tables, having different indexes on each) and more.

For now it provides a simple way to interact with DynamoDB and create/read rows in the table.  More features coming.

For Example, here I save a blog post:

First make sure that the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` shell variables are set to their respective values.

```coffeescript
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
blog_post.body = 'Dynasaur is a DynamoDB ORM that builds some neat features on top of DynamoDB'
blog_post.date = new Date()
blog_post.save (err,data) ->
  console.log err
```


