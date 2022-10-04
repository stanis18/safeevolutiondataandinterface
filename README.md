**ERC20**

## OpenZeppelin ERC20

## Commit 5b5d91 02_04_2020

```
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

```

## 0408e51 02_04_2020

```
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

```

## Commit  b8403b 04_02_2021

```
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

```

## OpenZeppelin ERC20Votes


## ad3c18 26_05_2021

```
   bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    mapping (address => address) private _delegates;
    mapping (address => Checkpoint[]) private _checkpoints;
```

## f6efd8 27_05_2021

```
    bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    mapping (address => address) private _delegates;
    mapping (address => Checkpoint[]) private _checkpoints;
    Checkpoint[] private _totalSupplyCheckpoints;
```

## e3661a 04_06_2021

```
    struct Checkpoint { uint32  fromBlock; uint224 votes; }
    bytes32 private constant _DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    mapping (address => address) private _delegates;
    mapping (address => Checkpoint[]) private _checkpoints;
    Checkpoint[] private _totalSupplyCheckpoints;
```


## Uniswap ERC20

## 4e4546 12_12_2019

```
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

## 5b15d5 13_12_2019

```
    string public name;
    string public symbol;
    uint8 public decimals;
    uint  public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

	bytes32 public DOMAIN_SEPARATOR;
	bytes32 public constant PERMIT_TYPEHASH = 0xf0a99559fef847d211c4182aa5791e1529af3ce414597e8210f570d662791c01;
    mapping (address => uint) public nonces;

```

## 55ae25 07_02_2020

```
    string public constant name = 'Uniswap V2';
    string public constant symbol = 'UNI-V2';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;
```

## 986d24 03_02_2020

```
    string public constant name = 'Uniswap V2';
    string public constant symbol = 'UNI-V2';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    uint public constant MINIMUM_TOTAL_SUPPLY = 10**4;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;
```

## e382d7 31_01_2020

```
    string public constant name = 'Uniswap V2';
    string public constant symbol = 'UNI-V2';
    uint8 public constant decimals = 18;
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    uint public constant THRESHOLD = 10**6;
    bytes32 public DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public nonces;

```

## OpenZeppelin ERC1155


## 91516b_02_06_2020

```
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
```

## a81e94_03_06_2020

```
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    string private _uri;
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
    bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
```

## 602059 29_01_2021

```
    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    string private _uri;
```