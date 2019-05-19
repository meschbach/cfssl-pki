const tls = require("tls");
const fs = require("fs");

const options = {
	ca: fs.readFileSync("root/ca.pem"),
	ciphers: "HIGH",
	honorCipherOrder: true
}

const socket = tls.connect( 9876, options, () => {
	console.log("Connected with ciphers: ", socket.getCipher());
});
