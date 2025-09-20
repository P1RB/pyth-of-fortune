// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.0;

import "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import "@pythnetwork/entropy-sdk-solidity/IEntropyV2.sol";

contract PrizeWheel is IEntropyConsumer {
    IEntropyV2 public entropy;

    // Example state to store randomness
    mapping(uint64 => bytes32) public randomResults;

    constructor(address entropyAddress) {
        require(entropyAddress != address(0), "Invalid entropy address");
        entropy = IEntropyV2(entropyAddress);
    }

    // Request randomness
    function requestRandomness() external payable returns (uint64 sequence) {
        // Using default provider and default gas limit
        sequence = entropy.requestV2{value: msg.value}();
    }

    // Implement entropyCallback from IEntropyConsumer
    function entropyCallback(
        uint64 sequence,
        address provider,
        bytes32 randomNumber
    ) internal override {
        // Store or use the randomness
        randomResults[sequence] = randomNumber;
        // Add game logic here
    }

    // Implement getEntropy required by IEntropyConsumer
    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }
}
