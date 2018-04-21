pragma solidity ^0.4.0;

contract SimpleCoin {

address owner;
uint256 constant TOTAL_SUPPLY = 10**18;

mapping (address => uint256) balances;

modifier onlyOwner() {
    if (msg.sender == owner) {
        _;
    }
}

event Transfer(address indexed _from, address indexed _to, uint256 _value);

constructor() public {
    owner = msg.sender;

    // Cheating - give some coins when creating the contract
    balances[owner] = 10000;
    balances[0xca35b7d915458ef540ade6068dfe2f44e8fa733c] = 10000;
    balances[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = 10000;
}

function totalSupply() pure public returns (uint256)
{
    return TOTAL_SUPPLY;
}

function balanceOf(address _owner) constant public returns (uint256)
{
    return balances[_owner];
}

function transfer(address _to, uint256 _value) public onlyOwner returns (bool)
{
    if (balances[msg.sender] > _value)
    {
        uint256 left = balances[msg.sender] - _value;
        balances[_to] += _value;
        balances[msg.sender] = left;

        // Event listener/filter will pick up
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    return false;
}

}

/*

[
    {
        "topic": "ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
        "event": "Transfer",
        "args": [
            "ca35b7d915458ef540ade6068dfe2f44e8fa733c",
            "14723a09acff6d2a60dcdf7aa4aff308fddc160c",
            "100"
        ]
    }
]

*/