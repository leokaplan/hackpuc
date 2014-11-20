express = require 'express'
body_parser = require 'body-parser'
app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/public')
app.use body_parser.json()
app.use body_parser.urlencoded(extended: true) 

get_type = (url) ->
  if url.match "[^\s]+\.(jpg|png|gif|bmp)"
    "image"
  else if url.match "[^\s]+\.youtube\.com/watch\\?v=\w*"
    console.log 'qq'
    # or string.match(url,"http://www%.youtu%.be/(%w*)(&(amp;)?[%w\?=]*)?")
    "youtube"
  else "link"

widget = (url) ->
    switch get_type(url)
        when "link"
            "<a href=\"" + url + "\" >" + url + "</a>"
        when "image"
            "<img src=\"" + url + "\">"
        when "youtube"
            id = url.match("[^\s]+\.youtube\.com/watch\?v=(\w*)")
            "<iframe id=\"ytplayer\" type=\"text/html\" width=\"640\" height=\"390\"
              src=\"http://www.youtube.com/embed/" + id + "?autoplay=1&origin=http://example.com\"frameborder=\"0\"/>"

html_dir = './public/';

app.get '/', (req, res) ->
  res.sendFile html_dir + 'index.html'

app.get '/note', (req, res) ->
  res.send """
        <html>
        <body>
        <h1>editor</h1>
        <div class="body">
                <form method="POST" action="/publish">
                        <input type="text" name="input" \>
                        <input type="submit" \>
                </form>
        </div>
        </body>
        </html>
        """

app.get '/note/:id', (req, res) ->
  res.send new Buffer(decodeURIComponent(req.params.id), 'base64').toString 'ascii'

app.post '/publish', (req, res) ->
  res.send encodeURIComponent(new Buffer(widget(decodeURIComponent(req.body.input))).toString 'base64')

app.listen app.get('port'), ->
  console.log "Node app is running at localhost:" + app.get('port')
