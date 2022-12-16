**ERC721**

### ERC721A

#### fb2262 12_02_2022

```solidity
    struct TokenOwnership {
        address addr;
        uint64 startTimestamp;
    ++  bool burned;
    }

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
    ++  uint64 numberBurned;
    }

    uint128 internal _currentIndex;
    uint128 internal _burnCounter;
    string private _name;
    string private _symbol;

    mapping(uint256 => TokenOwnership) internal _ownerships;
    mapping(address => AddressData) private _addressData;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
```

#### ddd119 18_02_2022

```solidity
    struct TokenOwnership {
        address addr;
        uint64 startTimestamp;
        bool burned;
    }

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
        uint64 numberBurned;
    ++  uint64 aux;
    }

    uint256 internal _currentIndex;
    uint256 internal _burnCounter;
    string private _name;
    string private _symbol;

    mapping(uint256 => TokenOwnership) internal _ownerships;
    mapping(address => AddressData) private _addressData;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
```



#### 3783cc 16_05_2022

```solidity
    uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
    uint256 private constant BITPOS_NUMBER_MINTED = 64;
    uint256 private constant BITPOS_NUMBER_BURNED = 128;
    uint256 private constant BITPOS_AUX = 192;
    uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
    uint256 private constant BITPOS_START_TIMESTAMP = 160;
    uint256 private constant BITMASK_BURNED = 1 << 224;
    uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
    uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
    uint256 internal _currentIndex;
    uint256 internal _burnCounter;

    string private _name;
    string private _symbol;
  
    mapping(uint256 => uint256) private _packedOwnerships;
    mapping(address => uint256) private _packedAddressData;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Example.. 
    
    function balanceOf(address owner) public view override returns (uint256) {
        if (owner == address(0)) revert BalanceQueryForZeroAddress();
        return uint256(_addressData[owner].balance);
    }
    function balanceOf(address owner) public view override returns (uint256) {
        if (owner == address(0)) revert BalanceQueryForZeroAddress();
        return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
    }
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _startTokenId() <= tokenId &&  tokenId < _currentIndex &&  _packedOwnerships[tokenId] & BITMASK_BURNED == 0; 
    }
```

#### 8f4644 11_07_2022

```solidity
    struct TokenApprovalRef {
        address value;
    }

    uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
    uint256 private constant BITPOS_NUMBER_MINTED = 64;
    uint256 private constant BITPOS_NUMBER_BURNED = 128;
    uint256 private constant BITPOS_AUX = 192;
    uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
    uint256 private constant BITPOS_START_TIMESTAMP = 160;
    uint256 private constant BITMASK_BURNED = 1 << 224;
    uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
    uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
    uint256 private constant BITPOS_EXTRA_DATA = 232;
    uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
    uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
    uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
    uint256 private _currentIndex;
    uint256 private _burnCounter;
    
    string private _name;
    string private _symbol;
   
    mapping(uint256 => uint256) private _packedOwnerships;
    mapping(address => uint256) private _packedAddressData;
    mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);

        if (_msgSenderERC721A() != owner)
            if (!isApprovedForAll(owner, _msgSenderERC721A())) {
                revert ApprovalCallerNotOwnerNorApproved();
            }
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }


    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);

        if (_msgSenderERC721A() != owner)
            if (!isApprovedForAll(owner, _msgSenderERC721A())) {
                revert ApprovalCallerNotOwnerNorApproved();
            }

        _tokenApprovals[tokenId].value = to;
        emit Approval(owner, to, tokenId);
    }
```

### OpenZeppelin ERC721

#### b7d60f 17_01_2019

```solidity
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    mapping (uint256 => address) private _tokenOwner;

    mapping (uint256 => address) private _tokenApprovals;

    mapping (address => uint256) private _ownedTokensCount;

    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    // Example... 
     function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _transferFrom(from, to, tokenId);
    }
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        require(to != address(0));
        _clearApproval(tokenId);
        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
        _tokenOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
```



#### 07603d 21_01_2019

```solidity
    library Counters {
        using SafeMath for uint256;

        struct Counter {
            uint256 _value; 
        }
    }
    
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    mapping (uint256 => address) private _tokenOwner;
    mapping (uint256 => address) private _tokenApprovals;

    mapping (address => Counters.Counter) private _ownedTokensCount;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    // Example... 

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _transferFrom(from, to, tokenId);
    }
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        require(to != address(0));
        _clearApproval(tokenId);
        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();
        _tokenOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
```

#### bd0778 02_04_2020

```solidity
    mapping (address => EnumerableSet.UintSet) private _holderTokens;

    EnumerableMap.UintToAddressMap private _tokenOwners;

    mapping (uint256 => address) private _tokenApprovals;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    mapping(uint256 => string) private _tokenURIs;

    string private _name;
    string private _symbol;
    string private _baseURI;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;


    library EnumerableSet {
        struct Set {
            bytes32[] _values;
            mapping (bytes32 => uint256) _indexes;
        }
    }

    library EnumerableMap {
        struct MapEntry {
            bytes32 _key;
            bytes32 _value;
        }
        struct Map {
            MapEntry[] _entries;
            mapping (bytes32 => uint256) _indexes;
        }
    }

    // Example... 

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);

        _holderTokens[from].remove(tokenId);
        _holderTokens[to].add(tokenId);
        _tokenOwners.set(tokenId, to);
        emit Transfer(from, to, tokenId);
    }

```


#### 09734e 21_01_2021

```solidity
    string private _name;
    string private _symbol;

    mapping (uint256 => address) private _owners;

    mapping (address => uint256) private _balances;

    mapping (uint256 => address) private _tokenApprovals;

    mapping (address => mapping (address => bool)) private _operatorApprovals;

    // Example... 

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");
        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
```


**ERC20**

## OpenZeppelin ERC20

#### 5b5d91 02_04_2020

```solidity
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

```

#### 0408e51 02_04_2020

```solidity
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
 ++ string private _name;
 ++ string private _symbol;
 ++ uint8 private _decimals;

```

#### b8403b 04_02_2021

```solidity
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
 -- uint8 private _decimals;
```

## OpenZeppelin ERC20Votes


#### ad3c18 26_05_2021

```solidity
   bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
   mapping (address => address) private _delegates;
   mapping (address => Checkpoint[]) private _checkpoints;
```

#### f6efd8 27_05_2021

```solidity
    bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    mapping (address => address) private _delegates;
    mapping (address => Checkpoint[]) private _checkpoints;
 ++ Checkpoint[] private _totalSupplyCheckpoints;
```

#### e3661a 04_06_2021

```solidity
 ++ struct Checkpoint { uint32  fromBlock; uint224 votes; } (Obs. moved!)
    bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    mapping (address => address) private _delegates;
    mapping (address => Checkpoint[]) private _checkpoints;
    Checkpoint[] private _totalSupplyCheckpoints;
```


## Uniswap ERC20

#### 4e4546 12_12_2019

```solidity
    string public name;
    string public symbol;
    uint8 public decimals;
    uint  public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
	bytes32 public DOMAIN_SEPARATOR;
	bytes32 public constant APPROVE_TYPEHASH = 0x25a0822e8c2ed7ff64a57c55df37ff176282195b9e0c9bb770ed24a300c89762;
    mapping (address => uint) public nonces;
```

#### 5b15d5 13_12_2019

```solidity
    string public name;
    string public symbol;
    uint8 public decimals;
    uint  public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
	bytes32 public DOMAIN_SEPARATOR;
 ++ bytes32 public constant PERMIT_TYPEHASH =       0xf0a99559fef847d211c4182aa5791e1529af3ce414597e8210f570d662791c01;
 -- bytes32 public constant APPROVE_TYPEHASH = 0x25a0822e8c2ed7ff64a57c55df37ff176282195b9e0c9bb770ed24a300c89762;
    mapping (address => uint) public nonces;

```

#### 55ae25 07_02_2020

```solidity
 +- string public constant name = 'Uniswap V2';
 +- string public constant symbol = 'UNI-V2';
 +- uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    bytes32 public DOMAIN_SEPARATOR;
 +- bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;
```

#### 986d24 03_02_2020

```solidity
    string public constant name = 'Uniswap V2';
    string public constant symbol = 'UNI-V2';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
 ++ uint public constant MINIMUM_TOTAL_SUPPLY = 10**4;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;
```

#### e382d7 31_01_2020

```solidity
    string public constant name = 'Uniswap V2';
    string public constant symbol = 'UNI-V2';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
 ++ uint public constant THRESHOLD = 10**6;
 -- uint public constant MINIMUM_TOTAL_SUPPLY = 10**4;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

```

## OpenZeppelin ERC1155


#### 91516b_02_06_2020

```solidity
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
```

#### a81e94_03_06_2020

```solidity
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    string private _uri;
 ++ bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
 ++ bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
```

#### 602059 29_01_2021

```solidity
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    string private _uri;
 -- bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
 -- bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
```


### Uniswap ERC20


#### 699aa8 31_10_2019
```solidity
    ++ function transferFrom(address from, address to, uint256 value) external returns (bool) {}
    ++ function burnFrom(address from, uint256 value) external {}
```

#### 7417b2 28_10_2019

```solidity
    ++ function approveMeta(address owner,	address spender, uint256 value,	uint256 nonce, uint256 expiration, uint8 v,bytes32 r, bytes32 s) external {}
```

#### c9d0ba 18_12_2019
```solidity
    -- function burn(uint value) external {}
    ++ function unsafeBurn(uint value) external {}
```
Obs: Alteração do nome da função.


#### e5b8db 25_10_2019

```solidity
    ++ function mint(address to, uint256 value) internal {}
```


## DigixDao ERC20


#### 0a9709 29_03_2016
```solidity
    ++ function registerDao(address _dao) ifOwner returns (bool success) {}
    ++ function registerSeller(address _tokensales) ifDao returns (bool success) {}
```

#### 83ad3e 17_04_2016
```solidity
    ++ function unregisterSeller(address _tokensales) ifDao returns (bool success) {}
```

#### 0390d2 21_04_2016
```solidity
    ++ function isSeller(address _query) returns (bool isseller) {}
```

#### 0550e8 24_03_2016
```solidity
    ++ function sendBadge(address _to, uint256 _value) returns (bool success) {}
```

#### 5571f9 07_03_2016
```solidity
    ++ function mint(address _owner, uint256 _amount) returns (bool success) {}
    ++ function Token(address _initseller) {}
```

#### e320a2 17_04_2016
```solidity
    ++ function setOwner(address _owner) ifOwner returns (bool success) {}
```