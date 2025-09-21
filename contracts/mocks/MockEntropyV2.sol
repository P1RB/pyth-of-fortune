// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";

contract MockEntropyV2 {
    uint64 public sequenceCounter;

    function requestV2() external payable returns (uint64) {
        sequenceCounter++;

        bytes32 randomNumber = keccak256(
            abi.encodePacked(block.timestamp, block.prevrandao, sequenceCounter)
        );

        // Call the external _entropyCallback function
        IEntropyConsumer(msg.sender)._entropyCallback(sequenceCounter, address(this), randomNumber);

        return sequenceCounter;
    }
}
