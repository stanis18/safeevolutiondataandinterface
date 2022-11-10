// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;


contract contractAB {

    uint256 numberA;
    uint256 numberB;
    
    /// @notice postcondition numberA == _numberA
    /// @notice postcondition numberB == _numberB
    constructor(uint256 _numberA, uint256 _numberB) public {
      numberA = _numberA; 
      numberB = _numberB;
    }

    /// @notice postcondition r == numberA + numberB
    function soma() public view returns (uint r){
      return numberA + numberB;
    }

}