const tls = require("tls");
const fs = require("fs");

const options = {
	ca: fs.readFileSync("root/ca.pem"),
	ciphers: "aECDSA:ECDSA",
	honorCipherOrder: true
}

tls.connect( 9876, options, (f) => {
	console.log("Connected");
});
