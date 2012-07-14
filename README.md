dynasaur
========

A DynamoDB ORM for Node.js

It aims to provide a few added features that most people will want from a DynamoDB tool.  These things include a Mongoose inspired way of doing things, periodic S3 backups, multi-indexing (clones data to seperate tables, having different indexes on each) and more.

For now it provides a simple way to interact with DynamoDB and create/read rows in the table.  More features coming.


## An Example

### Defining a Model


```coffeescript
module.exports = (dynasaur) ->

  blog_post_schema =
    attributes:
      author: String
      title: String
      body: String
      date: Number
    index: [{type:'hash',field:'author'}, {type:'range',fields:['title','date']}]

  BlogPost = dynasaur.model 'BlogPost', blog_post_schema
```



### Saving the blog post

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


## Stuff to come

* Periodic (user defined time) backups to S3
* Multi-indexing to allow one data type to be indexed via multiple keys (we'll use DynamoDB's strong consistency and data replication here)
* Elastic Map Reduce (so you can run SQL like queries over the data sets you store)


## Shoulders it stands on

A big thanks go out to Jed Schmidt and other contributors for [dynamo](https://github.com/jed/dynamo) which sits as an API abstraction for DynamoDB that made this process significantly easier.

Another big thanks go out to all the contributors of [mongoose](https://github.com/LearnBoost/mongoose) as it was a huge inspiration to the design of how users interact with the project.
