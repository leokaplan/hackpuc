lapis = require "lapis"
util = require "lapis.util"
encoding = require "lapis.util.encoding"

url_decode = (str) ->
    str = string.gsub(str, "+", " ")
    str = string.gsub(str, "%%(%x%x)", (h) -> string.char(tonumber(h,16)))
    str = string.gsub(str, "\r\n", "\n")
    str
url_encode = (str) ->
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", (c) -> string.format("%%%02X", string.byte(c)))
    str = string.gsub(str, " ", "+")
    str

get_type = (url) ->
    if string.match(url,"[^%s]+%.jpg") or string.match(url,"[^%s]+%.png") or string.match(url,"[^%s]+%.gif") or string.match(url,"[^%s]+%.bmp")
        "image"
    if string.match(url,"[^%s]+%.youtube%.com/watch%?v=(%w*)")-- or string.match(url,"http://www%.youtu%.be/(%w*)(&(amp;)?[%w\?=]*)?")
        "youtube"
    else
        "link"

widget = (url) ->
    switch get_type(url)
        when "link"
            "<a href=\""..url.."\" >"..url.."</a>"
        when "image"
            "<img src=\""..url.."\">"
        when "youtube"
            id = string.match(url,"[^%s]+%.youtube%.com/watch%?v=(%w*)")
            "<iframe id=\"ytplayer\" type=\"text/html\" width=\"640\" height=\"390\"
              src=\"http://www.youtube.com/embed/"..id.."?autoplay=1&origin=http://example.com\"frameborder=\"0\"/>"
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
  "/note/:id": => encoding.decode_base64(url_decode(@params.id))
  -- json/list_item_obj
  "/search/:query": => tojson(search(@params.query))
  --html/div
  [widget: "/widget/:url"]: => widget(@params.url)
  --json/string
  --[publish: "/publish"]: => encode(parse(@params.note))
  [publish: "/publish"]: => url_encode(encoding.encode_base64(widget(@params.input)))
  --[publish: "/publish"]: => widget(@params.input)
  --html
  --"/": => render: "error", status: 404
