// a static server that servers ./www/
var static = require('node-static');
var file = new static.Server('./www');
var port = 8080;

require('http').createServer(function (request, response) {
    request.addListener('end', function () {
        file.serve(request, response);
    }).resume();
}).listen(port);
console.log("Server running on port " + port + "...");
