// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import "@pythnetwork/entropy-sdk-solidity/IEntropyV2.sol";

contract PrizeWheel is IEntropyConsumer {
    IEntropyV2 public entropy;

    mapping(uint64 => bytes32) public randomResults;
    mapping(uint64 => string) public prizeResults;

    string[] public prizes = [
        "Cold Plunge With Pepito",
        "Tooth From Chop",
        "PLanck Toenail Clippings",
        "Noname Sock",
        "Bats4 Wing",
        "Lowkeighs Keys"
    ];

    // ===== ACCESS CONTROL FOR TESTING =====
    address public owner = msg.sender;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }
    // ===== END ACCESS CONTROL =====

    // Use the Base Sepolia Entropy V2 address
    constructor() {
        entropy = IEntropyV2(0x41c9e39574F40Ad34c79f1C99B66A45eFB830d4c);
    }

    function requestRandomness() external payable returns (uint64 sequence) {
        uint256 fee = entropy.getFeeV2();
        require(msg.value >= fee, "Insufficient fee");
        sequence = entropy.requestV2{value: fee}();
    }

    function entropyCallback(
        uint64 sequence,
        address /*provider*/,
        bytes32 randomNumber
    ) internal override {
        randomResults[sequence] = randomNumber;
        uint256 randIndex = uint256(randomNumber) % prizes.length;
        prizeResults[sequence] = prizes[randIndex];
    }

    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }

    function getPrize(uint64 sequence) external view returns (string memory) {
        return prizeResults[sequence];
    }

    // ===== TESTING ONLY =====
    function triggerCallbackForTesting(
        uint64 sequence,
        address provider,
        bytes32 randomNumber
    ) external onlyOwner {
        entropyCallback(sequence, provider, randomNumber);
    }
    // ===== END TESTING ONLY =====
}
