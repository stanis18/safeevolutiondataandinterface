// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;



interface IERC20Votes {
    

    function delegates(address owner) external view returns (address);
    function checkpoints(address account, uint32 pos) external view returns (Checkpoint memory);
    function numCheckpoints(address account) external view returns (uint32);
    function getCurrentVotes(address account) external view returns (uint256);
    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256);
    function getPriorTotalSupply(uint256 blockNumber) external view returns(uint256);
    function delegate(address delegatee) external;
    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
}
