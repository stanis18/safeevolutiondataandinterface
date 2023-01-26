import "./Interfaces.sol";

contract Token is TokenInterface {

  modifier noEther() {if (msg.value > 0) revert(); _;}

  function mint(address _owner, uint256 _amount) public returns (bool success) {
    success = true;
    return success;
  }

  constructor(address _initseller) public {
    seller[_initseller] = true; 
  }

  function transfer(address _to, uint256 _value) public noEther returns (bool success) {
    if (balances[msg.sender] >= _value && _value > 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  function transferFrom(address _from, address _to, uint256 _value) public noEther returns (bool success) {
    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function balanceOf(address _owner) public returns (uint256 balance) {
    return balances[_owner];
  }


  function allowance(address _owner, address _spender) public returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
}
