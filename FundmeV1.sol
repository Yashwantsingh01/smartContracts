// Get funds from users
// Withdraw funds
// Set minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; 

// Source: https://docs.chain.link/data-feeds/using-data-feeds/
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



contract FundMe{

    // payable keyword makes the function payable with ethereum or any other currency.
    function fund() public payable
    {
        // Set minimum fund amount in USD.
        uint minimumUsd = 50*1e18;
        // 1. How do we send ETH to this contract?


        /* get how much value somebody is sending
         * Required makes sure that certain fixed amount of ETH is sent or else the transaction fails, if any 
         * computation is done before required, it will cost GAS, but the calculation will be reverted on failure
         */
        require(getEthAmountInUsd(msg.value) > minimumUsd, "Please send minimum 1 ETH");  // 1e18 = 1 times 10 to the power 18 WEI

    }

    // Reference for data feeds: https://docs.chain.link/data-feeds/using-data-feeds
    // getter function to get the etherium price in USD
    function getPrice() public view returns(uint256)
    {
        // ABI :
        // Address : 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // Address source : https://docs.chain.link/data-feeds/price-feeds/addresses , https://docs.chain.link/data-feeds/price-feeds/addresses#Goerli%20Testnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        return uint256(price*1e10);

    }

    function getVersion() public view returns(uint)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getEthAmountInUsd(uint _ethAmount) public view returns(uint)
    {
        uint ethPrice = getPrice();

        // 1 ETH = 3000_000000000000000000 USD
        uint ethAmountToUsd = (ethPrice*_ethAmount)/1e18;
        return ethAmountToUsd;

    }

}
