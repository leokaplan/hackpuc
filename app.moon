lapis = require "lapis"
util = require "lapis.util"
encoding = require "lapis.util.encoding"
http = require "lapis.nginx.http"

-------------------------requires----------------------------------

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
table.key_to_str  = (k) ->
    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) 
        k
    else
        "[" .. table.val_to_str( k ) .. "]"

table.val_to_str = (v) ->
    if "string" == type(v) 
        v = string.gsub( v, "\n", "\\n" )
        if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) 
            "'" .. v .. "'"
        else
            '"' .. string.gsub(v,'"', '\\"' ) .. '"'
    else
        "table" == type( v ) and table.tostring( v ) or tostring( v )

table.tostring = (tbl) ->  
    result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, table.val_to_str(v))
        done[k] = true
    for k, v in pairs(tbl) do
        if not done[k] then
              table.insert(result,table.key_to_str(k).."="..table.val_to_str(v))
    "{"..table.concat(result,",").."}"
    
-----------------------utils--------------------------------------

get_type = (url) ->
    if string.match(url,"[^%s]+%.jpg") or string.match(url,"[^%s]+%.png") or string.match(url,"[^%s]+%.gif") or string.match(url,"[^%s]+%.bmp")
        "image"
    elseif string.match(url,"[^%s]+%.youtube%.com/watch%?v=(%w*)")-- or string.match(url,"http://www%.youtu%.be/(%w*)(&(amp;)?[%w\?=]*)?")
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

wikipedia = (query) ->
    url = "http://en.wikipedia.org/w/api.php?action=opensearch&search="..query
    res = util.from_json(http.request(url))
    res = item for item in *res[2,]
    --url.."</br>"..table.concat(res,"</br>")
    res

youtube = (query) ->
    url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q="..query.."&type=video"--&key={YOUR_API_KEY}"
    res = util.from_json(http.request(url))
    res = item for item in *res[2,]
    --url.."</br>"..table.concat(res,"</br>")
    res

mix = (tab) ->
    temp = {}
    for i=1,#tab do
        table.insert(temp,table.concat(tab[i],"</br>"))
    table.concat(temp,"</br>")
    temp
search = (query) ->
    table.concat(mix({youtube(query),wikipedia(query)}),"</br>")

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
  "/search/:query": => search(@params.query)
  --html/div
  [widget: "/widget/:url"]: => widget(@params.url)
  --json/string
  --[publish: "/publish"]: => encode(parse(@params.note))
  [publish: "/publish"]: => url_encode(encoding.encode_base64(widget(@params.input)))
  --[publish: "/publish"]: => widget(@params.input)
  --html
  --"/": => render: "error", status: 404
