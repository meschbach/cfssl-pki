const tls = require("tls");
// const net = require("net");
const fs = require("fs");

const cert = fs.readFileSync("servers/server-test-bundle.pem");
const key = fs.readFileSync("servers/server-test-key.pem");

const server = tls.createServer({
	cert: cert,
	key: key,
	enableTrace: true
}, (c) => {
	c.end();
});
server.listen(9876, () => {
	console.log("Listening");
});
