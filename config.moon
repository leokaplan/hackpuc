config 'production', ->
  port os.getenv "PORT"
    num_workers 4
    code_cache 'on'