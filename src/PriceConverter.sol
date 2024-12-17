// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    /**
     * @notice Fetches the latest ETH/USD price
     * @param priceFeed Chainlink AggregatorV3Interface address
     * @return The current price of 1 ETH in USD (scaled by 1e18)
     */
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 price, , ,) = priceFeed.latestRoundData();
        // Chainlink returns price with 8 decimals, so scale it to 1e18
        return uint256(price) * 1e10; 
    }

    /**
     * @notice Converts the given ETH amount to its USD value
     * @param ethAmount Amount of ETH in wei
     * @param priceFeed Chainlink AggregatorV3Interface address
     * @return USD value of the ETH amount (scaled by 1e18)
     */
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
