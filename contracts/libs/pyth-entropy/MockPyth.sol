// SPDX-License-Identifier: Apache-2
pragma solidity ^0.8.0;

import "./AbstractPyth.sol";
import "./PythStructs.sol";
import "./PythErrors.sol";

/**
 * @notice Mock contract for Pyth price feeds (for testing only).
 */
contract MockPyth is AbstractPyth {
    mapping(bytes32 => PythStructs.PriceFeed) priceFeeds;
    uint64 sequenceNumber;

    uint public singleUpdateFeeInWei;
    uint public validTimePeriod;

    constructor(uint _validTimePeriod, uint _singleUpdateFeeInWei) {
        validTimePeriod = _validTimePeriod;
        singleUpdateFeeInWei = _singleUpdateFeeInWei;
    }

    function queryPriceFeed(bytes32 id) public view override returns (PythStructs.PriceFeed memory) {
        if (priceFeeds[id].id == 0) revert PythErrors.PriceFeedNotFound();
        return priceFeeds[id];
    }

    function priceFeedExists(bytes32 id) public view override returns (bool) {
        return priceFeeds[id].id != 0;
    }

    function getValidTimePeriod() public view override returns (uint) {
        return validTimePeriod;
    }

    function updatePriceFeeds(bytes[] calldata updateData) public payable override {
        uint requiredFee = getUpdateFee(updateData);
        if (msg.value < requiredFee) revert PythErrors.InsufficientFee();

        uint16 chainId = 1;

        for (uint i = 0; i < updateData.length; i++) {
            PythStructs.PriceFeed memory priceFeed = abi.decode(updateData[i], (PythStructs.PriceFeed));
            uint lastPublishTime = priceFeeds[priceFeed.id].price.publishTime;

            if (lastPublishTime < priceFeed.price.publishTime) {
                priceFeeds[priceFeed.id] = priceFeed;
                emit PriceFeedUpdate(
                    priceFeed.id,
                    uint64(lastPublishTime),
                    priceFeed.price.price,
                    priceFeed.price.conf
                );
            }
        }

        emit BatchPriceFeedUpdate(chainId, sequenceNumber);
        sequenceNumber += 1;
    }

    function updatePriceFeedsIfNecessary(
        bytes[] calldata updateData,
        bytes32[] calldata priceIds,
        uint64[] calldata publishTimes
    ) external payable override {
        updatePriceFeeds(updateData); // Simplified for mock
    }

    function getUpdateFee(bytes[] calldata updateData) public view override returns (uint) {
        return singleUpdateFeeInWei * updateData.length;
    }

    function parsePriceFeedUpdates(
        bytes[] calldata updateData,
        bytes32[] calldata priceIds,
        uint64 minPublishTime,
        uint64 maxPublishTime
    ) external payable override returns (PythStructs.PriceFeed[] memory feeds) {
        feeds = new PythStructs.PriceFeed[](priceIds.length);
        for (uint i = 0; i < priceIds.length; i++) {
            for (uint j = 0; j < updateData.length; j++) {
                feeds[i] = abi.decode(updateData[j], (PythStructs.PriceFeed));
                if (feeds[i].id == priceIds[i]) {
                    uint publishTime = feeds[i].price.publishTime;
                    if (publishTime >= minPublishTime && publishTime <= maxPublishTime) {
                        break;
                    } else {
                        feeds[i].id = 0;
                    }
                }
            }
            if (feeds[i].id != priceIds[i]) revert PythErrors.PriceFeedNotFoundWithinRange();
        }
    }

    function createPriceFeedUpdateData(
        bytes32 id,
        int64 price,
        uint64 conf,
        int32 expo,
        int64 emaPrice,
        uint64 emaConf,
        uint64 publishTime
    ) public pure returns (bytes memory) {
        PythStructs.PriceFeed memory priceFeed;

        priceFeed.id = id;

        priceFeed.price.price = price;
        priceFeed.price.conf = conf;
        priceFeed.price.expo = expo;
        priceFeed.price.publishTime = publishTime;

        priceFeed.emaPrice.price = emaPrice;
        priceFeed.emaPrice.conf = emaConf;
        priceFeed.emaPrice.expo = expo;
        priceFeed.emaPrice.publishTime = publishTime;

        return abi.encode(priceFeed);
    }
}
