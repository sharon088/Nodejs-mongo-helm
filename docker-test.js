const http = require('http');
const express = require('express');
const app = new express();
const port = 8080;


app.get('/', function(request, response){
    response.writeHead(200, {'Content-Type': 'text/html'});
    response.end('Hello!');
});

app.get('/health', function(request, response){
    response.writeHead(200, {'Content-Type': 'text/html'});
    response.end('healthy');
});

app.get('/assignment', function(request, response){
    response.sendFile('devops-assignment-index.html', { root: __dirname });
});     

process.on('SIGINT', function() {
    console.log("Caught interrupt signal");
    process.exit();
});

app.listen(port, () => {
    console.log(`Starting Server at http://localhost:${port}`)
})