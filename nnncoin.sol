pragma solidity ^0.4.16;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract NNNcoin is owned {
    // create the Transfer even to be able to transfer tokens
    event Transfer(address indexed from, address indexed to, uint256 value);
    // create an event to freeze funds
    event FrozenFunds(address target, bool frozen);

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    mapping (address => bool) public frozenAccount;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    // Set the total supply balance with a variable called initialSupply
    function NNNcoin(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) {

    if (centralMinter != 0) owner = centralMinter;
    balanceOf[msg.sender] = initialSupply; // Give the total supply to the maker of the contract (me)
    name = tokenName;                         // Set the name of the token for display in Ethereum client
    symbol = tokenSymbol;                     // Set the symbol of the token for display in Ethereum client
    decimals = decimalUnits;                  // Set the amount of decimalUnits
    totalSupply = initialSupply;              // Start with the total supply as the initial supply at the start of the contract

  }

  function transfer(address _to, uint256 _value) {
    // Check if sender has enough balance to do the transaction and check for overflows
    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

    // Check if the account is not frozen
    require(!frozenAccount[msg.sender]);

    // Add the possiblity to transfer the token
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    // Notify anyone listening that this transfer took place
    Transfer(msg.sender, _to, _value);
  }


  // Add a function to increase the total supply of coins in circulation
  function mintToken(address target, uint256 mintedAmount) onlyOwner {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
}

  /*function _transfer(address _from, address _to, uint _value) internal {
      require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
      require(balanceOf[_from] >= _value);                 // Check if the sender has enough
      require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
      require(!frozenAccount[_from]);                     // Check if sender is frozen
      require(!frozenAccount[_to]);                       // Check if recipient is frozen
      balanceOf[_from] -= _value;                         // Subtract from the sender
      balanceOf[_to] += _value;                           // Add the same to the recipient
      Transfer(_from, _to, _value);
  }*/
  function freezeAccount(address target, bool freeze) onlyOwner {
      frozenAccount[target] = freeze;
      FrozenFunds(target, freeze);
  }

}
