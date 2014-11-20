lapis = require "lapis"
util = require "lapis.util"
encoding = require "lapis.util.encoding"

get_type = (url) ->
    if string.match(url,"[^%s]+%.jpg") or string.match(url,"[^%s]+%.png") or string.match(url,"[^%s]+%.gif") or string.match(url,"[^%s]+%.bmp")
        "image"
    else
        "link"
widget = (url) ->
    switch get_type(url)
        when "link"
            "<a href=\""..url.."\" >"..url.."</a>"
        when "image"
            "<img src=\""..url.."\">"
       -- when "youtube"
                     
class extends lapis.Application
  "/": => "oi"
  -- html
  "/note": => @html ->
    h1 "editor"
    div class:"body", ->
        form method: "POST", action:@url_for("publish"), ->
            input type: "text", name:"input"
            input type: "submit"
  -- html
  "/note/:id": => encoding.decode_base64(@params.id)
  -- json/list_item_obj
  "/search/:query": => tojson(search(@params.query))
  --html/div
  [widget: "/widget/:url"]: => widget(@params.url)
  --json/string
  --[publish: "/publish"]: => encode(parse(@params.note))
  [publish: "/publish"]: => encoding.encode_base64(widget(@params.input))
  --[publish: "/publish"]: => widget(@params.input)
  --html
  --"/": => render: "error", status: 404
