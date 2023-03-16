// SPDX-License-Identifier: MIT
pragma solidity 0.8.8; // Defining the verison of the solidity.
import "contracts/SimpleStorage.sol";

// EVM, Ethereum virtual machine
// Avalanche, Fantom, Polygon

contract StorageFactory{

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public 
    {
       SimpleStorage simpleStorage = new SimpleStorage();
       simpleStorageArray.push(simpleStorage);

    }

    // sf stands for storage factory, this function will be used to store number at particular smart contract!!!
    function sfStore(uint _simpleStorageIndex, uint _simpleStorageNumber) public
    {
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
     // simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);

    }

    //  getter function to check the number stored in the smart contract
    function sfget(uint _simpleStorageIndex) public view returns(uint)
    {
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
     // return simpleStorageArray[_simpleStorageIndex].retrieve();

    }

}
