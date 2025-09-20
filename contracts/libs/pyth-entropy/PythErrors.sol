// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

library PythErrors {
    error InvalidArgument();
    error InvalidUpdateDataSource();
    error InvalidUpdateData();
    error InsufficientFee();
    error NoFreshUpdate();
    error PriceFeedNotFoundWithinRange();
    error PriceFeedNotFound();
    error StalePrice();
    error InvalidWormholeVaa();
    error InvalidGovernanceMessage();
    error InvalidGovernanceTarget();
    error InvalidGovernanceDataSource();
    error OldGovernanceMessage();
}
