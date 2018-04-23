pragma solidity ^0.4.17;

// http://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
// http://solidity.readthedocs.io/en/develop/security-considerations.html#security-considerations

contract SafeWithdrawalFund {
    uint256 constant public MIN_WITHDRAW_GAS = 10**17;
    
    modifier onlyEnoughGas(uint256 _minGas) {
        require(msg.sender.balance >= _minGas);
        _;
    }
    
    event FundDeposited(address, uint256);
    event FundSent(address, uint256);
    
    constructor() public {
        
    }
    
    function deposit() payable public returns (uint256) {
        emit FundDeposited(msg.sender, msg.value);
        return msg.value;
    }
    
    function withdraw(uint256 _amount) onlyEnoughGas(MIN_WITHDRAW_GAS) public returns (bool) {
        require(_amount <= address(this).balance);
        
        if (msg.sender.send(_amount)) {
            emit FundSent(msg.sender, _amount);
            return true;
        }
        
        return false;
    }
}
