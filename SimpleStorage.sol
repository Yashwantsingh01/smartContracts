// SPDX-License-Identifier: MIT
// pragma solidity >=0.8.7 <0.9.0; // This means that any compiler between 0.8.7 and 0.9.0 will work.
// pragma solidity ^0.8.7; // This means that any version above 0.8.7 is okay for the contract.
pragma solidity 0.8.8; // Defining the verison of the solidity.

 // contract is like a class in c++
contract SimpleStorage{
// datatypes -> boolean, uint, int, address, bytes
//    bool hasFavouriteNumber = true;
//    uint favouriteNumber = 5;  this gets intialized to 5
//    string favouriteNumberInText = "Five";
//    address myAddress = 0xA75d6daf186465CB160aBd0DdB2D86A42b338577;
//    bytes32 favouriteBytes = "cat";

   uint public favouriteNumber;   // this gets initialized to zero
  // People public person = People({favouriteNumber: 4, name: "Yashwant"});
   People[] public people;
   mapping(string => uint) public nameToFavouriteNumber;

   struct People{
       uint favouriteNumber;
       string name;

   }

// virtual is added as this contract is used for inheritance in ExtraStorage contract.
   function store(uint _favouriteNumber) public virtual      
   {
       favouriteNumber = _favouriteNumber;
   }

   function addPerson(string memory _name, uint _favouriteNumber) public
   {
    //    People memory newPerson = People(_favouriteNumber, _name);
       People memory newPerson = People({favouriteNumber: _favouriteNumber, name: _name});
    //    people.push(People(_favouriteNumber, _name));
       people.push(newPerson);
       nameToFavouriteNumber[_name] = _favouriteNumber;
   
   }

// Implementation of getter function 
// view, pure fucntion doesnot allow modification of state and doesnot add to GAS cost 
// as we are simply reading the state and not modifying.
   function retrieve() public view returns(uint)
   {
       return favouriteNumber;
   }
}           

// contract address : 0xd9145CCE52D386f254917e481eB44e9943F39138
