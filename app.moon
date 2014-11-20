lapis = require "lapis"
util = require "lapis.util"
encoding = require "lapis.util.encoding"
                     
class extends lapis.Application
  "/": => "oi"
  -- html
  "/note": => @html ->
    h1 "editor"
    div class:"body", ->
        form method: "POST", action:@url_for("publish"), ->
            input type: "text", name:"input1"
            input type: "text", name:"input2"
            input type: "text", name:"input3"
            input type: "text", name:"input4"
            input type: "submit"
  -- html
  "/note/:id": => encoding.decode_base64(@params.id)
  -- json/list_item_obj
  "/search/:query": => tojson(search(@params.query))
  --html/div
  "/widget/:url": => widget(@params.url)
  --json/string
  --[publish: "/publish"]: => encode(parse(@params.note))
  [publish: "/publish"]: => encoding.encode_base64("#{@params.input1}</br>#{@params.input2}</br>#{@params.input3}</br>#{@params.input4}")
  --html
  --"/": => render: "error", status: 404
