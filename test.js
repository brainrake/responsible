// example nodejs server

let host = "127.0.0.1"
let port = "8000"

let listener = (req, res) => {
    console.log("ee")
    let m = req.method
    let u = req.url
    let h = req.headers
    letd = req.read()
    res.writeHead(200, {})
    res.end("ok")
}


let server = require('http').createServer()
server.on('listening', () => console.log("Listening on http://" + host + ":" + port + "/"))
server.on('request', listener)
server.on('error', (e) => console.log(e))
server.on('close', (e) => console.log('close'))
server.listen(port, host)
