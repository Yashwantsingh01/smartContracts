// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; // Defining the verison of the solidity.
import "contracts/SimpleStorage.sol";

// Inheritance
contract ExtraStorage is SimpleStorage{

   // Ovverride is added because we want the functinonality of storage in current contract to override SimpleStorage contract
    function store(uint _favouriteNumber) public override      
   {
       favouriteNumber = _favouriteNumber + 5;
   }

}
