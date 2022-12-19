**ERC721**

### ERC721A

#### fb2262 12_02_2022

```solidity
contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
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

    ++ uint128 internal _burnCounter;
...
}
```

#### ddd119 18_02_2022

```solidity
contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
        uint64 numberBurned;
    ++  uint64 aux;
    }
...
} 
```

#### 3783cc 16_05_2022

```solidity

contract ERC721A is IERC721A {
   
    ++ uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
    ++ uint256 private constant BITPOS_NUMBER_MINTED = 64;
    ++ uint256 private constant BITPOS_NUMBER_BURNED = 128;
    ++ uint256 private constant BITPOS_AUX = 192;
    ++ uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
    ++ uint256 private constant BITPOS_START_TIMESTAMP = 160;
    ++ uint256 private constant BITMASK_BURNED = 1 << 224;
    ++ uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
    ++ uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;

    -- mapping(uint256 => TokenOwnership) internal _ownerships;
    -- mapping(address => AddressData) private _addressData;

  
    ++ mapping(uint256 => uint256) private _packedOwnerships;
    ++ mapping(address => uint256) private _packedAddressData;
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
...
}
```

#### 8f4644 11_07_2022

```solidity
contract ERC721A is IERC721A {
   
    ++ struct TokenApprovalRef {
        address value;
    }

   ++ mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
   -- mapping(uint256 => address) private _tokenApprovals;

    // Example.. 

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
...
}
```

#### 3e1b7d 28_01_2022

```solidity

contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {    
    
    --  uint256 internal immutable maxBatchSize;

    constructor(  string memory name_, string memory symbol_,  --  uint256 maxBatchSize_ ) {
        require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
        _name = name_;
        _symbol = symbol_;
      --  maxBatchSize = maxBatchSize_;
    }
...
}
```
#### 7b3038 08_02_2022

```solidity
```
#### 7eae30 14_06_2022

```solidity
contract ERC721A is IERC721A {
    ++ uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
...
}    
```
#### 7fd5b8 15_08_2022

```solidity
    Obs: Não houve alterações na interface ou modelo de dados.. Mas é um commit interessante a ser analisado.
```
#### 9c15e6 11_01_2022

```solidity
contract ERC721A is Context, ERC165, IERC721,  IERC721Metadata, IERC721Enumerable {

  -- uint256 internal immutable collectionSize;

   constructor( string memory name_, string memory symbol_, uint256 maxBatchSize_, -- uint256 collectionSize_ ) {
    
    require(  collectionSize_ > 0, "ERC721A: collection must have a nonzero supply" );
    require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
    _name = name_;
    _symbol = symbol_;
    maxBatchSize = maxBatchSize_;
    -- collectionSize = collectionSize_;
  }
...
} 
```
#### c7248c 13_06_2022

```solidity
contract ERC721A is IERC721A {

  ++  uint256 private constant BITPOS_EXTRA_DATA = 232;
  ++  uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
...
} 
```


### OpenZeppelin ERC721


#### 07603d 21_01_2019

```solidity
contract ERC721 is ERC165, IERC721 {

  ++  library Counters {
        using SafeMath for uint256;

        struct Counter {
            uint256 _value; 
        }
    }
    
    -- mapping (address => uint256) private _ownedTokensCount;

    ++ mapping (address => Counters.Counter) private _ownedTokensCount;

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
...
}
```

#### bd0778 02_04_2020

```solidity
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {


    ++ library EnumerableSet {
        struct Set {
            bytes32[] _values;
            mapping (bytes32 => uint256) _indexes;
        }
    }

    ++ library EnumerableMap {
        struct MapEntry {
            bytes32 _key;
            bytes32 _value;
        }
        struct Map {
            MapEntry[] _entries;
            mapping (bytes32 => uint256) _indexes;
        }
    }

    ++ mapping (address => EnumerableSet.UintSet) private _holderTokens;
    ++ EnumerableMap.UintToAddressMap private _tokenOwners;

    -- mapping (uint256 => address) private _tokenOwner;
    -- mapping (address => Counters.Counter) private _ownedTokensCount;

    -- mapping(address => uint256[]) private _ownedTokens;
    -- mapping(uint256 => uint256) private _ownedTokensIndex;
    -- uint256[] private _allTokens;
    -- mapping(uint256 => uint256) private _allTokensIndex;

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
...
}
```


#### 09734e 19_02_2021

```solidity
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {

    -- mapping (address => EnumerableSet.UintSet) private _holderTokens;

    -- EnumerableMap.UintToAddressMap private _tokenOwners;

    -- mapping (uint256 => string) private _tokenURIs;

    -- string private _baseURI;

    ++ mapping (uint256 => address) private _owners;
    ++ mapping (address => uint256) private _balances;


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
...
}    
```


**ERC20**

### OpenZeppelin ERC20


#### 0408e51 02_04_2020

```solidity
contract ERC20 is Context, IERC20 {
   
 ++ string private _name;
 ++ string private _symbol;
 ++ uint8 private _decimals;
...
}
```

#### b8403b 04_02_2021

```solidity
contract ERC20 is Context, IERC20 {
    
 -- uint8 private _decimals;
...
} 
```

## OpenZeppelin ERC20Votes

#### f6efd8 27_05_2021

```solidity
 contract ERC20Votes is IERC20Votes, ERC20Permit {
    
    ++ Checkpoint[] private _totalSupplyCheckpoints;

    ++ function getPriorTotalSupply(uint256 blockNumber) external view override returns(uint256) {
        require(blockNumber < block.number, "ERC20Votes::getPriorTotalSupply: not yet determined");
        return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
    }
...
} 
```

#### e3661a 04_06_2021

```solidity
contract ERC20Votes is ERC20Permit {
 ++   struct Checkpoint {
        uint32  fromBlock;
        uint224 votes;
    }

Obs: O código foi movido do contrato pai para esse contrato.
...
}
```


## Uniswap ERC20 V2

#### 5b15d5 13_12_2019

```solidity
contract ERC20 is IERC20 {
   
 ++ bytes32 public constant PERMIT_TYPEHASH =      0xf0a99559fef847d211c4182aa5791e1529af3ce414597e8210f570d662791c01;
 -- bytes32 public constant APPROVE_TYPEHASH = 0x25a0822e8c2ed7ff64a57c55df37ff176282195b9e0c9bb770ed24a300c89762;
...
}
```

#### 55ae25 07_02_2020

```solidity
contract UniswapV2ERC20 is IUniswapV2ERC20 {
 
-- uint public constant MINIMUM_TOTAL_SUPPLY = 10**4;
...
}
```

#### 986d24 03_02_2020

```solidity
contract UniswapV2ERC20 is IUniswapV2ERC20 {
    -- uint public constant MINIMUM_TOTAL_SUPPLY = 10**6; 
    ++ uint public constant MINIMUM_TOTAL_SUPPLY = 10**4;
...
}
```

#### e382d7 31_01_2020

```solidity
contract UniswapV2ERC20 is IUniswapV2ERC20 {
 ++ uint public constant THRESHOLD = 10**6;
...
}
```

#### 7417b2 28_10_2019

```solidity
contract ERC20 is IERC20 {

++  mapping (address => uint) public nonceFor;
++	bytes32 public DOMAIN_SEPARATOR;
++  bytes32 public APPROVE_TYPEHASH = keccak256(
		"Approve(address owner,address spender,uint256 value,uint256 nonce,uint256 expiration)" );

++ function initialize(uint256 chainId) internal {
		require(DOMAIN_SEPARATOR == bytes32(0), "ERC20: ALREADY_INITIALIZED");
		DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)),
            keccak256(bytes("1")),
            chainId,
            address(this)
        ));
	}

++ function approveMeta( address owner, address spender, uint256 value, uint256 nonce,
		uint256 expiration, uint8 v, bytes32 r, bytes32 s) external {
		require(DOMAIN_SEPARATOR != bytes32(0), "ERC20: UNINITIALIZED");
        require(nonce == nonceFor[owner]++, "ERC20: INVALID_NONCE");
		require(expiration > block.timestamp, "ERC20: EXPIRED_SIGNATURE");

        bytes32 digest = keccak256(abi.encodePacked(
			byte(0x19),
			byte(0x01),
			DOMAIN_SEPARATOR,
			keccak256(abi.encode(
				APPROVE_TYPEHASH, owner, spender, value, nonce, expiration
			))
        ));
        require(owner == ecrecover(digest, v, r, s), "ERC20: INVALID_SIGNATURE"); // TODO add ECDSA checks? https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol

		_approve(msg.sender, spender, value);
	}
...
}
```

#### e5b8db 25_10_2019

```solidity
contract ERC20 is IERC20 {
++ function mint(address to, uint256 value) internal {
		totalSupply = totalSupply.add(value);
		balanceOf[to] = balanceOf[to].add(value);
		emit Transfer(address(0), to, value);
	}
...
}
```


### Tokens

#### 5caa1d 22_09_2017

```solidity
contract StandardToken is Token {
    ++  uint256 constant MAX_UINT256 = 2**256 - 1;
...
}
```

#### 5bddc4 04_07_2016

```solidity
contract StandardToken is Token {
    --  uint256 public totalSupply;
...
} 

Obs: A variável foi movida para a classe pai.
```


### OpenZeppelin ERC1155

#### a81e94_03_06_2020

```solidity
contract ERC1155 is ERC165, IERC1155, IERC1155MetadataURI {
    
    ++  string private _uri;
    ++  bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;

     function uri(uint256) external view override returns (string memory) {
        return _uri;
    }

    -- constructor() public {
        _registerInterface(_INTERFACE_ID_ERC1155);
    }

    ++ constructor (string memory uri) public {
        _setURI(uri);
        _registerInterface(_INTERFACE_ID_ERC1155);
        _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
    }

```

#### 602059 29_01_2021

```solidity
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {

 -- bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
 -- bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
...
}  
```

### DigixDao

#### 0a9709 29_03_2016


```solidity
contract TokenInterface {
    ...

    ++  address dao;
    ++  bool locked;
    ...
}

contract Token is TokenInterface {
    ...

   ++ function registerDao(address _dao) ifOwner returns (bool success) {
        if (locked == true) return false;
        dao = _dao;
        locked = true;
        return true;
  }

  ++ function registerSeller(address _tokensales) ifDao returns (bool success) {
        seller[_tokensales] = true;
  }

    ...
}     
```


#### 83ad3e 17_04_2016

```solidity
contract Token is TokenInterface {
    ...
    ++ function unregisterSeller(address _tokensales) ifDao returns (bool success) {
        seller[_tokensales] = false;
        return true;
    }
    ...
} 
```

#### 0390d2 21_04_2016

```solidity

contract Token is TokenInterface {
    ...
    ++ function isSeller(address _query) returns (bool isseller) {
        return seller[_query];
    } 
    ...
}    
```

#### 0550e8 24_03_2016

```solidity
contract TokenInterface {
    ...
    ++ uint256 public totalBadges;
    ...
}

contract Token is TokenInterface {
...

++ function badgesOf(address _owner) constant returns (uint256 badge) {
    return users[_owner].badges;
}

++ function sendBadge(address _to, uint256 _value) returns (bool success) {
    if (users[msg.sender].badges >= _value && _value > 0) {
      users[msg.sender].badges -= _value;
      users[_to].badges += _value;
      Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
}

++ function mintBadge(address _owner, uint256 _amount) ifSales returns (bool success) {
    totalBadges += _amount;
    users[_owner].badges += _amount;
    return success;
  }
...
}    
```

#### 5571f9 07_03_2016

```solidity

contract Token is TokenInterface {
    ...
 ++   function mint(address _owner, uint256 _amount) returns (bool success) {
        success = true;
        return success;
    }

++  function Token(address _initseller) {
    seller[_initseller] = true; 
  }
...
}    
```

#### e320a2 17_04_2016

```solidity

contract Token {
  ...
++ function setOwner(address _newowner) ifDao returns (bool success) {
    if(Badge(badgeLedger).setOwner(_newowner)) {
      owner = _newowner;
      success = true;
    } else {
      success = false;
    }
    return success;
  }

++  function setDao(address _newdao) ifDao returns (bool success) {
    dao = _newdao;
  }
...
}   
   
```

#### 6c717c 05_04_2016


```solidity


contract TokenInterface {

--  struct User {
    bool locked;
    uint256 balance;
    uint256 badges;
    mapping (address => uint256) allowed;
  }

--  mapping (address => User) users;
  mapping (address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;
  mapping (address => bool) seller;

  address config;
  address owner;
  address dao;
  bool locked;

...
}
```


### Bancor

#### 4176bb 03_10_2020

```solidity
contract SmartToken is ISmartToken, Owned, ERC20Token, TokenHolder { 
--    uint16 public constant version = 4; 
--    bool public transfersEnabled = true;
...
}
```

#### 5775c4 20_05_2017

```solidity
contract SmartToken is ERC20Token, Owned, ISmartToken {
    string public version = '0.1';
    bool public transfersEnabled = true;
--  address public changer = 0x0; 
++  ITokenChanger public changer;  
...
}
```

#### a7df76 05_05_2017

```solidity
contract SmartToken is Owned, ERC20Token, SmartTokenInterface { 
    string public version = '0.1'; 
    uint8 public numDecimalUnits = 0;   
 --   address public events = 0x0;         
    address public changer = 0x0;      
    bool public transfersEnabled = true; 
...
}
```

#### efdf6e 20_02_2021

```solidity
contract DSToken is IDSToken, ERC20, Owned, Utils {
    ++ uint8 private immutable tokenDecimals;
...
}    
```


### Crypto-Kitties


#### 0bf1bc 12_10_2020

```solidity
function getKitty(uint256 _kittyId)
        external
        view
        returns (
            uint256 kittyId,
            uint256 genes,
            uint64 birthTime,
            uint64 cooldownEndTime,
            uint32 mumId,
            uint32 dadId,
            uint16 generation,
            uint16 cooldownIndex,
       ++   address owner
        )
    {
        Kitty storage kitty = kitties[_kittyId];
        
        kittyId = _kittyId;
        genes = kitty.genes;
        birthTime = kitty.birthTime;
        cooldownEndTime = kitty.cooldownEndTime;
        mumId = kitty.mumId;
        dadId = kitty.dadId;
        generation = kitty.generation;
        cooldownIndex = kitty.cooldownIndex;
    ++  owner = kittyToOwner[_kittyId];
    }
```

#### a92c47 14_08_2020

```solidity
    contract KittyContract is IERC721 {
        ...
        ++ bytes4 _INTERFACE_ID_ERC165 = 0x01ffc9a7;
        ++ bytes4 _INTERFACE_ID_ERC721 = 0x80ac58cd;


        ++ function supportsInterface(bytes4 _interfaceId)
            external
            view
            returns (bool)
        {
            return (_interfaceId == _INTERFACE_ID_ERC165 ||
                _interfaceId == _INTERFACE_ID_ERC721);
        }
    ...
    }
```

#### db0846 13_08_2020

```solidity
++    function isKittyOwner(uint256 _kittyId) public view returns (bool) {
        return msg.sender == kittyToOwner[_kittyId];
    }

++ function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external onlyApproved(_tokenId) notZeroAddress(_to) {
        require(
            _from == kittyToOwner[_tokenId],
            "from address not kitty owner"
        );
        _transfer(_from, _to, _tokenId);
    }
```
#### f91664 05_09_2020

```solidity

  struct Kitty {
        uint256 genes;
        uint64 birthTime;
  ++    uint64 cooldownEndTime;
        uint32 mumId;
        uint32 dadId;
  ++    uint16 generation;
  ++    uint16 cooldownIndex;
    }


    function getKitty(uint256 _kittyId)
        external
        view
        returns (
            uint256 kittyId,
            uint256 genes,
            uint64 birthTime,
        ++    uint64 cooldownEndTime,
            uint32 mumId,
            uint32 dadId,
        ++    uint16 generation,
        ++    uint16 cooldownIndex
        )

    {
        Kitty storage kitty = kitties[_kittyId];
        return (
            _kittyId,
            kitty.genes,
            kitty.birthTime,
            kitty.cooldownEndTime,
            kitty.mumId,
            kitty.dadId,
            kitty.generation,
            kitty.cooldownIndex
        );
    }

```
### Set-Protocol

#### 23e484 27_04_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18), Set {
    ++  uint public naturalUnit;
    
    constructor(address[] _components, uint[] _units, ++ uint _naturalUnit) public {
        ...
        require(_naturalUnit > 0);
        naturalUnit = _naturalUnit;
        ...
    }
 ...
}

```
#### 187f9b 25_02_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18), Set {

  ++ uint256 public totalSupply;

  ++ function tokenCount() public view returns(uint tokensLength) {
    return tokens.length;
  }
...
}
```
#### 5999fc 19_05_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18), SetInterface {

    -- mapping(bytes32 => mapping(address => uint)) internal unredeemedBalances;
    ++ mapping(uint => mapping(address => uint)) internal unredeemedBalances;
...
}    
```
#### 573434 31_07_2018

```solidity
contract SetToken is StandardToken, DetailedERC20 {
   -- string constant COMPONENTS_INPUT_MISMATCH = "Components and units must be the same length.";
   --  string constant COMPONENTS_MISSING = "Components must not be empty.";
   --  string constant INVALID_COMPONENT_UNIT = "Unit declarations must be non-zero.";
   --  string constant INVALID_COMPONENT_ADDRESS = "Components must have non-zero address.";
   --  string constant INVALID_NATURAL_UNIT = "Natural unit does not work with component decimals.";
   --  string constant INVALID_SENDER = "Sender is not permitted to perform this function.";
   --  string constant UNITS_MISSING = "Units must not be empty.";
   --  string constant ZERO_QUANTITY = "Quantity must be greater than zero.";
...
} 
```
#### ae657d 14_06_2018

```solidity
contract SetToken is StandardToken, DetailedERC20 {
 ++ string constant INVALID_SENDER = "Sender is not permitted to perform this function.";
 ++ address public factory;
...
}     
```
#### b1cc53 08_11_2018

```solidity
contract SetToken is ERC20, RC20Detailed {
--    struct Component {
        address address_;
        uint256 unit_;
    }

--    Component[] public components;

 ++   address[] public components;
 ++   uint256[] public units;
...
}    
```

#### be95aa 09_04_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18), Set {

++  struct PartialRedeemStatus {
        uint unredeemedBalance;
        bool isRedeemed;
  }
  
++  mapping(address => mapping(address => PartialRedeemStatus)) public unredeemedComponents;

++ function partialRedeem(uint quantity, address[] excludedComponents) public hasSufficientBalance(quantity)
    preventRedeemReEntrancy(msg.sender, quantity) returns (bool success) {

    require(excludedComponents.length < components.length);

    for (uint i = 0; i < components.length; i++) {
      bool isExcluded = false;
      uint transferValue = units[i].fxpMul(quantity, 10**9);
      assert(transferValue > 0);

      for (uint j = 0; j < excludedComponents.length; j++) {
        address currentExcluded = excludedComponents[j];
        assert(isComponent[currentExcluded]);

        if (components[i] == currentExcluded) {
          bool currentIsRedeemed = unredeemedComponents[components[i]][msg.sender].isRedeemed;
          assert(currentIsRedeemed == false);
          unredeemedComponents[components[i]][msg.sender].unredeemedBalance += transferValue;
          unredeemedComponents[components[i]][msg.sender].isRedeemed = true;
          isExcluded = true;
        }
      }

      if (isExcluded == false) {
        assert(ERC20(components[i]).transfer(msg.sender, transferValue));  
      }
    }

    for (uint k = 0; k < excludedComponents.length; k++) {
      address currentExcludedToUnredeem = excludedComponents[k];
      unredeemedComponents[currentExcludedToUnredeem][msg.sender].isRedeemed = false;
    }

    LogPartialRedemption(msg.sender, quantity);
    return true;
  }

...
}     
```
#### bf85e7 10_08_2018

```solidity
contract SetToken is StandardToken, DetailedERC20 {
    -- mapping(bytes32 => bool) internal isComponent;
    ++ mapping(address => bool) internal isComponent;
...
}    
```
#### cad51f 13_11_2017

```solidity
contract SetToken is Set, StandardToken {
    --  mapping(address => bool) addressExists;

    -- function checkNoDuplicateAddresses(address[] _addresses) internal constant returns (bool noDuplicate) {
    for (uint i = 0; i < _addresses.length; i++) {
      address currentAddress = _addresses[i];

      if (addressExists[currentAddress]) {
        return false;
      }

      addressExists[currentAddress] = true;
    }

    return true;
  }
...
}    
```
#### e63ae2 11_06_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18) {

++  string constant COMPONENTS_INPUT_MISMATCH = "Components and units must be the same length.";
++  string constant COMPONENTS_MISSING = "Components must not be empty.";
++  string constant UNITS_MISSING = "Units must not be empty.";
++  string constant ZERO_QUANTITY = "Quantity must be greater than zero.";

--   mapping(uint => mapping(address => uint)) internal unredeemedBalances;

++  function burn( uint quantity) external {
        balances[msg.sender] = balances[msg.sender].sub(quantity);
        totalSupply_ = totalSupply_.sub(quantity);
        emit Transfer(msg.sender, address(0), quantity);
    }
...
}     
```
#### e85133 26_04_2018

```solidity
contract SetToken is StandardToken, DetailedERC20("", "", 18), Set {
 --- address[] public components;
 -- uint[] public units;
 -- mapping(address => bool) internal isComponent;

++   struct Component {
    address address_;
    uint unit_;
  }

 ++ Component[] public components;
++ mapping(address => bool) internal isComponent;
...
}  

```