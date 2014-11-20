import config from require "lapis.config"

config 'production', ->
  port os.getenv "PORT"
    num_workers 4
    code_cache 'on'