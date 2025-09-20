// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./libs/pyth-entropy/EntropyStructs.sol";
import "./libs/pyth-entropy/Entropy.sol";


contract PrizeWheel {
    IPythEntropy public entropy;

    constructor(address _entropy) {
        entropy = IPythEntropy(_entropy);
    }

    function spinWheel() public view returns (uint256) {
        return entropy.getRandomNumber(msg.sender) % 100;
    }
}
