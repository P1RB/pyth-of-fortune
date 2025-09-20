// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IPyth.sol";
import "./PythStructs.sol";
import "./PythErrors.sol";

abstract contract AbstractPyth is IPyth {
    function queryPriceFeed(bytes32 id) public view virtual returns (PythStructs.PriceFeed memory priceFeed);
    function priceFeedExists(bytes32 id) public view virtual returns (bool exists);

    function getValidTimePeriod() public view virtual override returns (uint validTimePeriod);

    function getPrice(bytes32 id) external view virtual override returns (PythStructs.Price memory price) {
        return getPriceNoOlderThan(id, getValidTimePeriod());
    }

    function getEmaPrice(bytes32 id) external view virtual override returns (PythStructs.Price memory price) {
        return getEmaPriceNoOlderThan(id, getValidTimePeriod());
    }

    function getPriceUnsafe(bytes32 id) public view virtual override returns (PythStructs.Price memory price) {
        return queryPriceFeed(id).price;
    }

    function getPriceNoOlderThan(bytes32 id, uint age) public view virtual override returns (PythStructs.Price memory price) {
        price = getPriceUnsafe(id);
        if (block.timestamp > price.publishTime + age) revert PythErrors.StalePrice();
    }

    function getEmaPriceUnsafe(bytes32 id) public view virtual override returns (PythStructs.Price memory price) {
        return queryPriceFeed(id).emaPrice;
    }

    function getEmaPriceNoOlderThan(bytes32 id, uint age) public view virtual override returns (PythStructs.Price memory price) {
        price = getEmaPriceUnsafe(id);
        if (block.timestamp > price.publishTime + age) revert PythErrors.StalePrice();
    }

    function updatePriceFeeds(bytes[] calldata updateData) public payable virtual override;
    function updatePriceFeedsIfNecessary(bytes[] calldata updateData, bytes32[] calldata priceIds, uint64[] calldata publishTimes) external payable virtual override;
    function parsePriceFeedUpdates(bytes[] calldata updateData, bytes32[] calldata priceIds, uint64 minPublishTime, uint64 maxPublishTime) external payable virtual override returns (PythStructs.PriceFeed[] memory priceFeeds);
}
