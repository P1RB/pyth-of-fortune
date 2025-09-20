// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@pythnetwork/entropy-sdk-solidity/PythEntropy.sol";

// Renamed contract
contract PythOfFortune is PythEntropy {

    address public owner;
    uint256 public maxSpinsPerUser;
    mapping(address => uint256) public userSpins;

    // Event name can also be more specific
    event SpinResult(address indexed user, uint256 prizeIndex, string prizeName);

    // Constructor for Base Sepolia Testnet
    constructor(
        uint256 _maxSpins
    ) PythEntropy(0x6c97598c0E521aFdE4E8ed6f59e2c7b063B5c66d) {
        owner = msg.sender;
        maxSpinsPerUser = _maxSpins;

        // Add your prizes here. Weights are relative.
        prizes.push(Prize("Common Prize", 50));
        prizes.push(Prize("Rare Prize", 30));
        prizes.push(Prize("Epic Prize", 15));
        prizes.push(Prize("Legendary Prize", 5));
    }

    function spinTheWheel() external payable {
        require(userSpins[msg.sender] < maxSpinsPerUser, "No spins left");
        (uint64 sequenceNumber, bytes32 randomNumber) = request(msg.sender, false);
        _fulfillRandomNumber(randomNumber);
        userSpins[msg.sender] += 1;
    }

    function _fulfillRandomNumber(bytes32 _randomNumber) internal {
        // ... (implementation from previous step)
    }
}
