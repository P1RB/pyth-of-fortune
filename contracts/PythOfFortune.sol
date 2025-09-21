// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.0;

import "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import "@pythnetwork/entropy-sdk-solidity/IEntropyV2.sol";

contract PythOfFortune is IEntropyConsumer {
    IEntropyV2 public entropy;

    mapping(uint64 => bytes32) public results;

    constructor(address entropyAddress) {
        require(entropyAddress != address(0), "Invalid entropy address");
        entropy = IEntropyV2(entropyAddress);
    }

    // Request randomness from Pyth Entropy V2
    function requestRandomness() external payable returns (uint64 sequence) {
        sequence = entropy.requestV2{value: msg.value}();
    }

    // Handle the random number callback from Entropy
    function entropyCallback(
        uint64 sequence,
        address provider,
        bytes32 randomNumber
    ) internal override {
        results[sequence] = randomNumber;
        // Add Pyth-of-Fortune game logic here
    }

    // Return the Entropy contract address
    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }
}
