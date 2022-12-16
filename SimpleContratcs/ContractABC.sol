// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

/// @notice invariant numberC == numberA + numberB
contract contractABC {

    uint256 numberA;
    uint256 numberB;
    uint256 numberC;
    
    /// @notice postcondition numberA == _numberA
    /// @notice postcondition numberB == _numberB
    constructor(uint256 _numberA, uint256 _numberB) public {
      numberA = _numberA; 
      numberB = _numberB;
      numberC = numberA + numberB;
    }

    /// @notice postcondition r == numberC
    function soma() public view returns (uint r) {
      return numberC;
    }

}