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

    // Request randomness
    function requestRandomness() external payable returns (uint64 sequence) {
        // Default provider, default gas limit
        sequence = entropy.requestV2{value: msg.value}();
    }

    // Callback from entropy
    function entropyCallback(
        uint64 sequence,
        address provider,
        bytes32 randomNumber
    ) internal override {
        results[sequence] = randomNumber;
        // Add your Pyth-of-Fortune game logic here
    }

    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }
}
