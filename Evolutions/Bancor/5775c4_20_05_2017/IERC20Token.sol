pragma solidity ^0.4.10;

/*
    ERC20 Standard Token interface
*/
contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public  returns (string name) {}
    function symbol() public  returns (string symbol) {}
    function decimals() public  returns (uint8 decimals) {}
    function totalSupply() public  returns (uint256 totalSupply) {}
    function balanceOf(address _owner) public  returns (uint256 balance) {}
    function allowance(address _owner, address _spender) public returns (uint256 remaining) {}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}
