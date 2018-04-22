# Upgrading a Token

## Thought Process

* Let's say we have an ERC20 token
* We want to upgrade it to ERC777 token
* We need to create a conversion contract UpgradeToken
* When users call UpgradeToken contract, the contract must do:
  * Deduct/destroy the old token
  * Deduct the balance of old token from the user address
  * Increase the balance of the new token to the user address
* Security considerations
  * UpgradeToken will have to call 2 token contracts
  * Check to verify the address of the source & target tokens
  * Check ownership of the user
  * msg.sender will be address of the smart contract that calls the other smart contract
  * Back-up/save the original caller's address to pass through the stack of smart contract calls
  * Upgrade is quite complicated & error-prone

## Concrete Steps

1) The user must do 2 steps:
* Call Old ERC20::approve(addressOf ConversionContract)
* Call ConversionContract::convert(amount)

2) ConversionContract::convert will do:
* Check Old ERC20::allowance
* Call Old ERC20::transferFrom(userOldAddr, proofOfBurnAddr, value)
* Burn the old ERC20
* Send ERC777 to the userAddr

3) Setup/funding ERC777
* Pre-fund (could be a waste or hard to tell why fund is there)
* Mint on-demand when conversion is called

```
* transferFrom(address _from, address _to, uint256 _value) returns (bool success)[Send _value amount of tokens from address _from to address _to]
* approve(address _spender, uint256 _value) returns (bool success) [Allow _spender to withdraw from your account, multiple times, up to the _value amount. If this function is called again it overwrites the current allowance with _value]
* allowance(address *_owner*, address *_spender*) constant returns (uint256 remaining) [Returns the amount which _spender is still allowed to withdraw from _owner]
```

## Notes

* Only indexed fields emitted by Solidity Events will be indexed by the Log Bloom Filter (they will be a little costlier):

    event AddToCart(uint256 indexed DIN, address indexed buyer);

* Note that Solidity Event data will be stored in Receipt State Tree and the caller will have to pay for their storage (there's cost per byte).

* You can listen/subscribe to Solidity Events and then re-publish them via web3.shh (Whisper) or use for your event-driven apps

* The only way to provide data for Oracles is to call them to update internal state of the Oracle smart contracts.

* The contracts that need Oracle data will have to call the Oracle.

* It's up to the owners/admins of the Oracle to decide consensus/update rules for their Oracles

## References

https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

https://medium.com/@jgm.orinoco/understanding-erc-20-token-contracts-a809a7310aa5

https://theethereum.wiki/w/index.php/ERC20_Token_Standard

https://github.com/OpenZeppelin/zeppelin-solidity/issues/438

https://www.reddit.com/r/ethereum/comments/7qjw6x/everything_you_need_to_know_about_erc777_the_new/

https://en.wikipedia.org/wiki/ERC20

Implementation

There are already plenty of ERC20-compliant tokens deployed on the Ethereum network. Different implementations have been written by various teams that have different trade-offs: from gas saving to improved security.
Example implementations are available at

    https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
    https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol

Implementation of adding the force to 0 before calling "approve" again:

    https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol

