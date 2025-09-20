// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPythEvents {
    event PriceFeedUpdate(
        bytes32 indexed id,
        uint64 publishTime,
        int64 price,
        uint64 conf
    );

    event BatchPriceFeedUpdate(uint16 chainId, uint64 sequenceNumber);
}
