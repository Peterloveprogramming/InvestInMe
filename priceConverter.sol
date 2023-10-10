pragma solidity >=0.8.2 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
        function getPrice() internal view returns (uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
    //ABI 
    // Address 
        //0x694AA1769357215DE4FAC081bf1f309aDC325306
        return uint(answer*1e10);
    }

    
    function getGBPToUSDConversionRate() internal view returns (uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x91FAB41F5f3bE955963a986366edAcff1aaeaa83);
        (,int256 answer,,,) = priceFeed.latestRoundData();
    //ABI 
    // Address 
        //0x694AA1769357215DE4FAC081bf1f309aDC325306
        return uint(answer*1e10);
    }

    function EthToGBPConversionRate(uint256 ethAmount) internal view returns (uint256){
        // get the price of USD in terms of 1 Eth
        uint256 ethPriceInUSD = getPrice() * ethAmount;
        uint256 ethPriceInGBP = ethPriceInUSD/getGBPToUSDConversionRate();

        return ethPriceInGBP;
    }
  
}