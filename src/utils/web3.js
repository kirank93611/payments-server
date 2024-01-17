const Web3 = require("web3");
const rpc = MUMBAI_RPC;

const web3 = new Web3(rpc);

module.exports = { web3 };
