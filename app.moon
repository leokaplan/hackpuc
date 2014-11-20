lapis = require "lapis"
util = require "lapis.util"
encoding = require "lapis.util.encoding"
http = require "lapis.nginx.http"

-------------------------requires----------------------------------

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
