// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;



contract NewToken {
    constructor(){
        owner = msg.sender;
    }


    // public variables 
    string public tokenName = "mytoke";
    string public tokenAbbrv = "mytokeabbrv";
    uint public totalSupply = 0;
    address public owner;

    //events
    event Burn(address indexed from, uint amount);
    event Mint(address indexed to, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    // mapping variable 
    mapping(address => uint) public balances;

    //error handling
    error InsufficientBalance(uint balance, uint withdrawAmount);

    //modifier
    modifier onlyOwner{
        assert (msg.sender == owner);
        _;
    }

    // mint function
    function mint(address _address, uint _value) public onlyOwner{
        totalSupply += _value;
        balances[_address] += _value;
        emit Mint(_address, _value);
    }

    // burn function
    function burn(address _address, uint _value) public onlyOwner{
        if (balances[_address] < _value) {
            revert InsufficientBalance({balance: balances[_address], withdrawAmount: _value});
        }else{
            totalSupply -= _value;
            balances[_address] -= _value;
            emit Mint(_address, _value);
        }
    }

    //transfer function
    function transfer(address _recepient, uint _value) public {
        require(balances [msg.sender] >= _value, "Account balance must be greater then transfered value!"); 
        balances [msg.sender] -= _value;
        balances [_recepient] += _value;
        emit Transfer(msg.sender, _recepient, _value);
    }
}
