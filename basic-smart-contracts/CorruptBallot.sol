pragma solidity ^0.4.17;

// https://www.theblockchainconnector.com/workshop/tasks.html

import "./ballot.sol";

contract CorruptBallot is Ballot {
    // proposal => (voter => (briber => amount))
    mapping (uint8 => mapping (address => mapping (address => uint256))) proposalVoterBribes;
    mapping (address => mapping (uint8 => uint256)) bribesOwed;

    event VoterBribed(uint8 _proposal, address _from, address _to, uint256 _amount);
    event VoterBribePaid(uint8 _proposal, address _to, uint256 _amount);

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
        proposalVoterBribes[_proposal][_to][msg.sender] += msg.value;
        bribesOwed[_to][_proposal] += msg.value;

        emit VoterBribed(_proposal, msg.sender, _to, msg.value);
    }

    /// Give a single vote to proposal $(toProposal).
    // https://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
    function vote(uint8 _proposal) onlyValidProposalModifier(_proposal) onlyValidVoterModifier(msg.sender) public returns (bool _voteValid) {
        _voteValid = super.vote(_proposal);
        assert(_voteValid == true);

        // Pay the voter if she voted according to the bribe
        address _voter = msg.sender;
        uint256 _payout = bribesOwed[_voter][_proposal];
        if (_payout > 0) {
            // Transfer the payout to the voter
            _voter.transfer(_payout);

            // No more payout owed to the voter for this proposal
            bribesOwed[_voter][_proposal] = 0;

            // Record the payout
            emit VoterBribePaid(_proposal, _voter, _payout);
        }
    }

    function canVote(address _person) view public returns (bool) {
        return (voters[_person].voted == false && voters[_person].weight > 0);
    }
}
