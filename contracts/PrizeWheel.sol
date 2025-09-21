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

    constructor(address entropyAddress) {
        require(entropyAddress != address(0), "Invalid entropy address");
        entropy = IEntropyV2(entropyAddress);
    }

    function requestRandomness() external payable returns (uint64 sequence) {
        sequence = entropy.requestV2{value: msg.value}();
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

    function triggerCallbackForTesting(
        uint64 sequence,
        address provider,
        bytes32 randomNumber
    ) external {
        entropyCallback(sequence, provider, randomNumber);
    }
}
