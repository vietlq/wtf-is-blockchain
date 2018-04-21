# Upgrading a Token

https://medium.com/@jgm.orinoco/understanding-erc-20-token-contracts-a809a7310aa5

https://theethereum.wiki/w/index.php/ERC20_Token_Standard

https://github.com/OpenZeppelin/zeppelin-solidity/issues/438

https://www.reddit.com/r/ethereum/comments/7qjw6x/everything_you_need_to_know_about_erc777_the_new/

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