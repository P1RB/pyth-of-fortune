// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import Pyth Entropy interface (pseudo-import, replace with correct package once installed)
import {IPythEntropy} from "@pythnetwork/entropy-sdk-solidity/IPythEntropy.sol";

contract PrizeWheel {
    IPythEntropy public entropy; // randomness provider
    address public owner;

    // Each prize is just a string for now
    string[] public prizes;

    // Track spins so each wallet can only spin once
    mapping(address => bool) public hasSpun;

    event PrizeWon(address indexed player, uint indexed prizeIndex, string prize);

    constructor(address _entropy, string[] memory _prizes) {
        entropy = IPythEntropy(_entropy);
        owner = msg.sender;
        for (uint i = 0; i < _prizes.length; i++) {
            prizes.push(_prizes[i]);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addPrize(string memory _prize) external onlyOwner {
        prizes.push(_prize);
    }

    function spin() external {
        require(!hasSpun[msg.sender], "Already spun");
        require(prizes.length > 0, "No prizes set");

        // Get entropy randomness (simplified)
        uint random = uint(keccak256(abi.encodePacked(entropy.getRandom(), msg.sender, block.timestamp)));

        uint prizeIndex = random % prizes.length;
        string memory won = prizes[prizeIndex];

        hasSpun[msg.sender] = true;
        emit PrizeWon(msg.sender, prizeIndex, won);
    }
}

