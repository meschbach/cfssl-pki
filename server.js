const tls = require("tls");
// const net = require("net");
const fs = require("fs");

const cert = fs.readFileSync("servers/server-test-bundle.pem");
const key = fs.readFileSync("servers/server-test-key.pem");

const server = tls.createServer({
	cert: cert,
	key: key,
	enableTrace: true,
	ciphers: "ECDHE-RSA-RC4-SHA:RC4:HIGH:!MD5:!aNULL:!EDH",
}, (c) => {
	console.log("Connected.");
	c.on("error", (e) => console.error(e) );
	setTimeout(() => {
		c.end("test");
	}, 1000);
});
server.listen(9876, () => {
	console.log("Listening");
});

