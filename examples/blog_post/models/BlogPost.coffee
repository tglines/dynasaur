module.exports = (dynasaur) ->

  blog_post_schema =
    attributes:
      author: String
      title: String
      body: String
      date: Number
    index: [{type:'hash',field:'author'}, {type:'range',fields:['title','date']}]

  BlogPost = dynasaur.model 'BlogPost', blog_post_schema
