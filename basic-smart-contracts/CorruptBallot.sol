pragma solidity ^0.4.17;

// https://www.theblockchainconnector.com/workshop/tasks.html

import "./ballot.sol";

contract CorruptBallot is Ballot {
    // proposal => (voter => (briber => amount))
    mapping (uint8 => mapping(address => mapping(address => uint256))) proposalVoterBribes;

    event BribeVoter(uint8 _proposal, address _from, address _to, uint256 _amount);

    modifier onlyValidVoterModifier(address _voter) {
        require(voters[_voter].voted == false && voters[_voter].weight > 0);
        _;
    }

    modifier onlyValidProposalModifier(uint8 _proposal) {
        require(_proposal < proposals.length);
        _;
    }

    /// Create a new ballot with $(_numProposals) different proposals.
    constructor (uint8 _numProposals) Ballot(_numProposals) public {
    }

    // The keyword payable will allow the function to receive the ETH and keep the amount
    // Access the amount via msg.value
    // To deposit, simply send a valid value of ETH to the contract when calling this function
    function bribe(address _to, uint8 _proposal) payable onlyValidProposalModifier(_proposal) onlyValidVoterModifier(_to) public {
        if(proposalVoterBribes[_proposal][_to][msg.sender] > 0) {
            proposalVoterBribes[_proposal][_to][msg.sender] += msg.value;
        } else {
            proposalVoterBribes[_proposal][_to][msg.sender] = msg.value;
        }

        emit BribeVoter(_proposal, msg.sender, _to, msg.value);
    }

    /// Give a single vote to proposal $(toProposal).
    // https://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
    function vote(uint8 _proposal) onlyValidProposalModifier(_proposal) public returns (bool _voteValid) {
        super.vote(_proposal);
    }
}
