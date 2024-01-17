const crypto = require("crypto");
const { v4: uuidv4 } = require("uuid");

function createSalt() {
	const hash = crypto.createHash("sha256");
	const uid = uuidv4();
	const SECRET = process.env.SALT_SECRET || "salt-secret";
	hash.update(`${SECRET}-${uid}`);

	console.log(`Original String: ${`${SECRET}-${uid}`}`);

	return hash.digest("hex");
}

// const hashedString = createSalt();
// console.log(`Hashed String: ${hashedString}`);

module.exports = { createSalt }