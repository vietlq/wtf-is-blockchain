pragma solidity ^0.4.0;

// https://www.theblockchainconnector.com/workshop/tasks.html

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

* https://codeburst.io/deep-dive-into-ethereum-logs-a8d2047c7371

* https://ethereumbuilders.gitbooks.io/guide/content/en/ethereum_javascript_api.html#contract-events

* https://blockgeeks.com/ethereum-smart-contract-clients/

* https://coursetro.com/posts/code/100/Solidity-Events-Tutorial---Using-Web3.js-to-Listen-for-Smart-Contract-Events

* https://blog.gridplus.io/scaling-blockchains-with-apache-kafka-814c85781c6

* https://medium.com/etherereum-salon/eth-testing-472c2f73b4c3

* https://programtheblockchain.com/dapps/counter-with-events/
* https://programtheblockchain.com/dapps/multicounter/
* https://programtheblockchain.com/posts/2018/01/24/logging-and-watching-solidity-events/

* https://nethereum.readthedocs.io/en/latest/contracts/calling-transactions-events/

* https://media.consensys.net/technical-introduction-to-events-and-logs-in-ethereum-a074d65dd61e?gi=618f94773407

* https://github.com/ethereum/go-ethereum/wiki/RPC-PUB-SUB

* https://ethereum.stackexchange.com/questions/1381/how-do-i-parse-the-transaction-receipt-log-with-web3-js

* https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethfilter

*/

/*

Event topic ID is SHA3 of its signature!

https://codeburst.io/deep-dive-into-ethereum-logs-a8d2047c7371

> sha3('Pregnant(address,uint256,uint256,uint256)')
241ea03ca20251805084d27d4440371c34a0b85ff108f6bb5611248f73818b80

> sha3('Transfer(address,address,uint256)')
ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

> sha3('Approval(address,address,uint256)')
8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925

> sha3('Birth(address,uint256,uint256,uint256,uint256)')
0a5311bd2a6608f08a180df2ee7c5946819a649b204b554bb8e39825b2c50ad5

> sha3('ContractUpgrade(address)')
450db8da6efbe9c22f2347f7c2021231df1fc58d3ae9a2fa75d39fa446199305

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