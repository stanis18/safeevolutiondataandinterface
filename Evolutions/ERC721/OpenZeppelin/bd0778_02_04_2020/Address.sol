pragma solidity >=0.5.0 <0.9.0;


library Address {
   
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        // bytes32 codehash;
        // bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // // solhint-d isable-next-line no-inline-assembly
        // assembly { codehash := extcodehash(account) }
        // return (codehash != accountHash && codehash != 0x0);
    }

    
    function sendValue(address payable recipient, uint256 amount) internal {
        // require(address(this).balance >= amount, "Address: insufficient balance");

        // // solhint-d isable-next-line avoid-low-level-calls, avoid-call-value
        // (bool success, ) = recipient.call.value(amount)("");
        // require(success, "Address: unable to send value, recipient may have reverted");
    }
}
