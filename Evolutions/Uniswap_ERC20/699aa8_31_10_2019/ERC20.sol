// https://github.com/makerdao/dss/blob/b1fdcfc9b2ab7961bf2ce7ab4008bfcec1c73a88/src/dai.sol
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/2f9ae975c8bdc5c7f7fa26204896f6c717f07164/contracts/token/ERC20
pragma solidity 0.5.12;

import "../interfaces/IERC20.sol";

import "../libraries/SafeMath256.sol";

/// @notice  invariant  totalSupply  ==  __verifier_sum_uint(balanceOf)
contract ERC20 is IERC20 {
    using SafeMath256 for uint256;

    // ERC-20 data
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // ERC-191 data
    uint256 public chainId;
    mapping (address => uint) public nonceFor;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        mint(msg.sender, _totalSupply);
    }

    function initialize(uint256 _chainId) internal {
        require(chainId == 0, "ERC20: ALREADY_INITIALIZED");
        chainId = _chainId;
    }

    /// @notice  emits  Transfer
    function mint(address to, uint256 value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    /// @notice  emits  Transfer
    function _burn(address from, uint256 value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    /// @notice  emits  Transfer
    function _transfer(address from, address to, uint256 value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    /// @notice  emits  Approval
    function _approve(address owner, address spender, uint256 value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /// @notice  postcondition ( ( balanceOf_[msg.sender] ==  __verifier_old_uint (balanceOf_[msg.sender] ) - value  && msg.sender  != to ) ||   ( balanceOf_[msg.sender] ==  __verifier_old_uint ( balanceOf_[msg.sender]) && msg.sender  == to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) + value  && msg.sender  != to ) ||   ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) && msg.sender  == to ) &&  success )   || !success
    /// @notice  emits  Transfer 
    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }

    /// @notice  postcondition (allowance_[msg.sender ][ spender] ==  value  &&  success) || ( allowance_[msg.sender ][ spender] ==  __verifier_old_uint ( allowance_[msg.sender ][ spender] ) && !success )    
    /// @notice  emits  Approval
    function approve(address spender, uint256 value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function approveMeta(
        address owner,
        address spender,
        uint256 value,
        uint256 nonce,
        uint256 expiration,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(chainId != 0, "ERC20: UNINITIALIZED");
        require(nonce == nonceFor[owner]++, "ERC20: INVALID_NONCE");
        require(expiration > block.timestamp, "ERC20: EXPIRED_SIGNATURE");

        bytes32 digest = keccak256(abi.encodePacked(
            hex'19',
            hex'00',
            address(this),
            keccak256(abi.encodePacked(
                owner, spender, value, nonce, expiration, chainId
            ))
        ));
        // TODO add ECDSA checks? https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
        require(owner == ecrecover(digest, v, r, s), "ERC20: INVALID_SIGNATURE");

        _approve(owner, spender, value);
    }

    /// @notice  postcondition ( ( balanceOf_[from] ==  __verifier_old_uint (balanceOf_[from] ) - value  &&  from  != to ) ||   ( balanceOf_[from] ==  __verifier_old_uint ( balanceOf_[from] ) &&  from== to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) + value  &&  from  != to ) ||   ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) &&  from  ==to ) &&  success )   || !success
    /// @notice  postcondition  (allowance_[from ][msg.sender] ==  __verifier_old_uint (allowance_[from ][msg.sender] ) - value && success)  || (allowance_[from ][msg.sender] ==  __verifier_old_uint (allowance_[from ][msg.sender] ) && !success) || from  == msg.sender
    /// @notice  postcondition  allowance_[from ][msg.sender]  <= __verifier_old_uint (allowance_[from ][msg.sender] ) ||  from  == msg.sender
    /// @notice  emits  Transfer
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        if (allowance[from][msg.sender] != uint256(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function burnFrom(address from, uint256 value) external {
        if (allowance[from][msg.sender] != uint256(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _burn(from, value);
    }
}
