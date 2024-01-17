// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract TempContract {
    // address public immutable recieverAddress;
    // address public immutable adminAddress;

    constructor(address _recieverAddress) payable {
        // recieverAddress = _recieverAddress; //Need to put address as input instead of msg.sender because msg.sender will be another contract with CREATE2 salt deploy.
        // adminAddress = msg.sender;
        selfdestruct(payable(_recieverAddress)); //Deletes all data from this contract.
    }

    // function killThisContract() public { //After a contract is killed at an address, you can deploy another contract at that address.
    //     require(msg.sender == adminAddress, "Only contract can call this function!");
    //     selfdestruct(payable(recieverAddress)); //Deletes all data from this contract.
    // }
    // Use fallbacks and recieve for donation type payments
    // fallback() external payable { 
    //     killThisContract();
    // }

    // receive() external payable { 
    //     killThisContract();
    // }
}

contract Factory { //Modified from: "Create2 | Solidity 0.8" by  Smart Contract Programmer https://www.youtube.com/watch?v=883-koWrsO4&ab_channel=SmartContractProgrammer
    address public immutable owner;
    event create2Event(address deployedAddressEvent);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function!");
        _;
    }

    function deploy(bytes32 _salt, address _recieverAddress) public payable onlyOwner {  // Salt example:  0x0000000000000000000000000000000000000000000000000000000000000000
        TempContract tempContract = new TempContract {value: msg.value, salt: _salt}(_recieverAddress); // Another salt example: 0x123456789abcdef0000000000000000000000000000000000000000000000000
        emit create2Event(address(tempContract));
    }

    function precomputeAddress(bytes32 _salt, address _recieverAddress) public view returns (address) {
        bytes memory creationCodeValue = abi.encodePacked(type(TempContract).creationCode, abi.encode(_recieverAddress));
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(creationCodeValue)));
        return address(uint160(uint(hash)));
    }
}