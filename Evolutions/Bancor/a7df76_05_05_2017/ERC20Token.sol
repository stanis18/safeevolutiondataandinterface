pragma solidity ^0.4.10;
import './ERC20TokenInterface.sol';
import 'SafeMath.sol';

/*
    ERC20 Standard Token implementation
*/
contract ERC20Token is ERC20TokenInterface, SafeMath {
    string public standard = 'Token 0.1';
    string public name = '';
    string public symbol = '';
    uint256 public totalSupply = 0;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function ERC20Token(string _name, string _symbol) {
        name = _name;
        symbol = _symbol;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        assert(_address != 0x0);
        _;
    }

    /*
        send coins
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
    */
    function transfer(address _to, uint256 _value)
        public
        validAddress(_to)
        returns (bool success)
    {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /*
        an account/contract attempts to get the coins
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
    */
    function transferFrom(address _from, address _to, uint256 _value)
        public
        validAddress(_from)
        validAddress(_to)
        returns (bool success)
    {
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        balanceOf[_from] = safeSub(balanceOf[_from], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    /*
        allow another account/contract to spend some tokens on your behalf
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors

        also, to minimize the risk of the approve/transferFrom attack vector
        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
    */
    function approve(address _spender, uint256 _value)
        public
        validAddress(_spender)
        returns (bool success)
    {
        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
        require(_value == 0 || allowance[msg.sender][_spender] == 0);

        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}
