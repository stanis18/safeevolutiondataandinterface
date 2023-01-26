pragma solidity >=0.5.0 <0.9.0;

import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";

/// @notice  invariant  totalSupply  ==  __verifier_sum_uint(balanceOf)
contract ERC20 is IERC20 {
    using SafeMath for uint;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint  public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

	bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 expiration)");
	bytes32 public constant PERMIT_TYPEHASH = 0xf0a99559fef847d211c4182aa5791e1529af3ce414597e8210f570d662791c01;
    mapping (address => uint) public nonces;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        if (_totalSupply > 0) {
            _mint(msg.sender, _totalSupply);
        }
        uint chainId = 1; // hardcode as 1 until ethereum-waffle support istanbul-specific EVM opcodes
        // assembly { chainId := chainid() }  // solium-disable-line security/no-inline-assembly
        DOMAIN_SEPARATOR = keccak256(abi.encode(
			keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
			keccak256(bytes(name)),
			keccak256(bytes("1")),
			chainId,
			address(this)
		));
    }

    /// @notice  emits  Transfer
    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    /// @notice  emits  Transfer
    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    /// @notice  emits  Transfer
    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    /// @notice  emits  Approval
    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /// @notice  postcondition ( ( balanceOf_[msg.sender] ==  __verifier_old_uint (balanceOf_[msg.sender] ) - value  && msg.sender  != to ) ||   ( balanceOf_[msg.sender] ==  __verifier_old_uint ( balanceOf_[msg.sender]) && msg.sender  == to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) + value  && msg.sender  != to ) ||   ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) && msg.sender  == to ) &&  success )   || !success
    /// @notice  emits  Transfer 
    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function burn(uint value) external {
        _burn(msg.sender, value);
    }

    /// @notice  postcondition (allowance_[msg.sender ][ spender] ==  value  &&  success) || ( allowance_[msg.sender ][ spender] ==  __verifier_old_uint ( allowance_[msg.sender ][ spender] ) && !success )    
    /// @notice  emits  Approval
    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

     /// @notice  postcondition ( ( balanceOf_[from] ==  __verifier_old_uint (balanceOf_[from] ) - value  &&  from  != to ) ||   ( balanceOf_[from] ==  __verifier_old_uint ( balanceOf_[from] ) &&  from== to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) + value  &&  from  != to ) ||   ( balanceOf_[to] ==  __verifier_old_uint ( balanceOf_[to] ) &&  from  ==to ) &&  success )   || !success
    /// @notice  postcondition  (allowance_[from ][msg.sender] ==  __verifier_old_uint (allowance_[from ][msg.sender] ) - value && success)  || (allowance_[from ][msg.sender] ==  __verifier_old_uint (allowance_[from ][msg.sender] ) && !success) || from  == msg.sender
    /// @notice  postcondition  allowance_[from ][msg.sender]  <= __verifier_old_uint (allowance_[from ][msg.sender] ) ||  from  == msg.sender
    /// @notice  emits  Transfer
    function transferFrom(address from, address to, uint value) external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function burnFrom(address from, uint value) external {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _burn(from, value);
    }

    function permit(
        address owner, address spender, uint value, uint nonce, uint expiration, uint8 v, bytes32 r, bytes32 s
    )
        external
    {
        require(nonce == nonces[owner]++, "ERC20: INVALID_NONCE");
        require(expiration > block.timestamp, "ERC20: EXPIRED"); // solium-disable-line security/no-block-members
        require(v == 27 || v == 28, "ERC20: INVALID_V");
        require(uint(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ERC20: INVALID_S");
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, expiration))
        ));
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, "ERC20: INVALID_SIGNATURE");
        _approve(owner, spender, value);
    }
}
