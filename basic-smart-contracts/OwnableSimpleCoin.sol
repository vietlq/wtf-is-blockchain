pragma solidity ^0.4.0;

// http://solidity.readthedocs.io/en/develop/introduction-to-smart-contracts.html

// http://remix.readthedocs.io/en/latest/tutorial_import.html
import "./Ownable.sol";
//import "https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol";

contract OwnableSimpleCoin is Ownable {

uint256 constant TOTAL_SUPPLY = 10**18;

mapping (address => uint256) balances;

mapping (address => bool) whitelist;

uint256 maxAmount = 1000;

modifier notExceed(uint256 _value) {
    require(_value <= maxAmount);
    _;
}

modifier onlyWhitelisted() {
    require(whitelist[msg.sender]);
    _;
}

event Transfer(address indexed _from, address indexed _to, uint256 _value);

constructor() public {
    // Cheating - give some coins when creating the contract
    balances[0xca35b7d915458ef540ade6068dfe2f44e8fa733c] = 10000;
    balances[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = 10000;
}

// Administrative functions

// https://ethereum.stackexchange.com/questions/25200/solidity-what-is-the-difference-between-view-and-constant
// https://ethereum.stackexchange.com/questions/28898/when-to-use-view-and-pure-in-place-of-constant
function getMaxAmount() view public returns(uint256) {
    return maxAmount;
}

function setMaxAmount(uint256 _maxAmount) public onlyOwner returns(bool) {
    if (_maxAmount >= TOTAL_SUPPLY) {
        return false;
    }

    maxAmount = _maxAmount;

    return true;
}

// Return values only serve internal functions
// To inform external callers, you must emit events
function whitelistAddress(address _addr) public onlyOwner {
    // emit successful addition to the whitelist
    whitelist[_addr] = true;
}

function dewhitelistAddress(address _addr) public onlyOwner {
    if (whitelist[_addr]) {
        // emit successful removal from the whitelist
        delete whitelist[_addr];
    }
}

// Functions for general public

function totalSupply() pure public returns (uint256)
{
    return TOTAL_SUPPLY;
}

function balanceOf(address _owner) constant public returns (uint256)
{
    return balances[_owner];
}

function transfer(address _to, uint256 _value) public notExceed(_value) returns (bool)
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

// You can chain modifiers one after another
function whitelistedTransfer(address _to, uint256 _value) public notExceed(_value) onlyWhitelisted returns (bool)
{
    return transfer(_to, _value);
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