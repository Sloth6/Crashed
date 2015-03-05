express = require 'express'
app = express()
coffeeMiddleware = require 'coffee-middleware'
# view engine setup
app.set 'views', __dirname+'/views'
app.set 'view engine', 'jade'
app.use express.static(__dirname+'/public')

app.use coffeeMiddleware {
  src: __dirname+'/public'
  compress: false
  encodeSrc: false
  force: true
  debug: true
  bare: true
}

app.get '/', (req, res) ->
  res.render 'phaser', {}

# catch 404 and forward to error handler
app.get '*', (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err


# development error handler
# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status || 500
  res.render 'error', {
      message: err.message,
      error: {}
  }

server = app.listen 3000, ()->
  host = server.address().address
  port = server.address().port
  console.log 'Crashed listening at http://%s:%s', host, port
