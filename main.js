var express = require('express');
var app = express();

app.configure(function(){

  if (process.env.NODE_ENV === 'development') {
    // Put development environment only routes + code here
  }
  
  // Must be the last route so that everything falls back to the dist dir
  app.use(express.static(__dirname + '/dist'));
});

app.listen(3000);
