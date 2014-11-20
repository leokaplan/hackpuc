lapis = require "lapis"

class extends lapis.Application
  "/": => "oi"
  -- html
  "/note/": => editor!
  -- html
  "/note/:id/": => asm_page(decode(@params.id))
  -- json/list_item_obj
  "/search/:query/": => tojson(search(@params.query))
  --html/div
  "/widget/:url/": => widget(@params.url)
  --json/string
  "/publish/:note/": => encode(parse(@params.note))
  --html
  "*": =>  render(404)
