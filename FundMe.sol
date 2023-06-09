// Get funds from users
// Withdraw funds
// Set minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; 

// Source: https://docs.chain.link/data-feeds/using-data-feeds/
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract FundMe{

    // Set minimum fund amount in USD. (using constant[for gloabal declarations, immutable for functions] here reduces the GAS required)
    uint constant MINIMUM_USD = 50*1e18;

    // Array of addressess to store senders addressess.
    address[] public funders;

    // We wish to store how much money is funded by each person
    mapping(address => uint) public addressToAmountFunded;

    // immutable works as constant but used for functions (it saves GAS)
    address public immutable i_owner;

    // We are setting up the constructor to set the owner of the contract, as we want to make sure later that
    // only owner is able to withdraw the fund.
    constructor()
    {
        // msg.sender initially contains the address of te person who deployed the contract, hence the owner. 
        i_owner = msg.sender;
    }

    // payable keyword makes the function payable with ethereum or any other currency.
    function fund() public payable
    {
        // 1. How do we send ETH to this contract?
        /* get how much value somebody is sending
         * Required makes sure that certain fixed amount of ETH is sent or else the transaction fails, if any 
         * computation is done before required, it will cost GAS, but the calculation will be reverted on failure
         */
        require(getEthAmountInUsd(msg.value) > MINIMUM_USD, "Please send minimum 50USD");  // 1e18 = 1 times 10 to the power 18 WEI
        
        // As the transaction is successfull we can update the funder address list.
        funders.push(msg.sender);

        // Mapping amount sent by the sender to the senders address.
        addressToAmountFunded[msg.sender] = msg.value;
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

    function withdraw() public OnlyOwner
    {
        // Making sure that the wallet funds are sent back to the owner (this can alternatively be done by modifier onlyOwner as above).
        // require(msg.sender == owner, "Sender is not owner!");

        // Iterating though funders array, to get the address of each funder and setting the wallet amount to zero.
        // starting index, ending index, step amount
        for(uint funderIndex = 0; funderIndex < funders.length; funderIndex++)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Reset funders array containing addresses by new Address array with zero objects.
        funders = new address[](0);

        // Withdraw the funds
        /*
        Three different ways to send back the currency
        1) transfer
        2) Send
        3) Call
        */
        // Transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // adress(this) = address of the current contract.
        payable(msg.sender).transfer(address(this).balance);

        // send
        bool sendSucess = payable(msg.sender).send(address(this).balance);
        require(sendSucess, "Send Failed");

        // Call 
        // Returns bool and data, best way to withdraw funds
        (bool callSucess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucess, "call Failed");
    }

    modifier OnlyOwner 
    {
        require(msg.sender == i_owner, "Sender is not owner!");

        // do rest of the code
        _;

        // Here we can add code if we want to execute something post executing the code of the function where the modifier is used  
    }

    // If somebody sends this contract an ETH without calling the fund function, we can still process it
    // To understand receive and callback refer to FallbackExample.sol
    // ETH goes as a transfer when these methods are triggered.
    receive() external payable
    {
        fund();
    }

    fallback() external payable
    {
        fund();
    }
}
