/*
receive() function is a special function in solidity.
1) It cant have any arguments
2) Its immutable
3) It dosent need function keyword to define.
4) These functions should be defined as external payable.
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; 

contract FallbackExample
{
    uint public result;

    // This function is triggered when ETH is sent and data is not sent.
    receive() external payable
    {
        result = 1;
    }

    // This function is triggered when ETH is sent and data is sent along with it.
    // To send the data, put some data in CALLDATA and fallback() will be triggered.
    fallback() external payable
    {
        result = 2;
    }
}
