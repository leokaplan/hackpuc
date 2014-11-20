lapis = require "lapis"

class extends lapis.Application
  "/": => "oi"
  "/note/": => editor!
  "/note/:id": => asm_page(@params.id)
  "/search/:query": => 
  "/select/:id": =>
  "/getlink/:id": =>
  "*": => 
