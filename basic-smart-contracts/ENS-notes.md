# Ethereum Name System

ENS has smart design: Separate Resolvers for upgradability. One can upgrade, downgrade, change, move Resolvers to handle various resources, requests.

Think:
+ Old Resolver supports only domain names myname.eth
+ New Resolver for Subdomains xxx.myname.eth

Request flow:
1) Get the resolver for the ENS name from the ENS Smart Contract
2) Call the resolver to resolve the ENS name

** Read constant/view/pure Smart Contracts functions from clients (JS/Python/...) will not spend gas - free! However if you call those functions from other Smart Contracts, you still have to pay gas. **

```
var test = ens.resolver('myaddr.eth').instance()
```

* Only indexed fields emitted by Solidity Events will be indexed by the Log Bloom Filter (they will be a little costlier):

    event AddToCart(uint256 indexed DIN, address indexed buyer);

* Note that Solidity Event data will be stored in Receipt State Tree and the caller will have to pay for their storage (there's cost per byte).

* You can listen/subscribe to Solidity Events and then re-publish them via web3.shh (Whisper) or use for your event-driven apps

* The only way to provide data for Oracles is to call them to update internal state of the Oracle smart contracts.

* The contracts that need Oracle data will have to call the Oracle.

* It's up to the owners/admins of the Oracle to decide consensus/update rules for their Oracles