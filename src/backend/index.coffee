express = require 'express'
app = express()

app.configure ->

  #if process.env.NODE_ENV is 'development'
    # Put development environment only routes + code here
  
  # Must be the last route so that everything falls back to the dist dir
  # Note that the directory tree is relative to the 'BACKEND_LIBDIR' Makefile
  # variable (`lib` by default) directory
  app.use(express.static(__dirname + '/../public'))

app.listen 3000
console.log "Listening at http://localhost:3000"
