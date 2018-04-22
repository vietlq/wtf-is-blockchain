pragma solidity ^0.4.17;

import "./ballot.sol";

contract CorruptBallot is Ballot {
    // proposal => (voter => (briber => amount))
    mapping (uint8 => mapping(address => mapping(address => uint256))) proposalVoterBribes;

    event BribeVoter(uint8 _proposal, address _from, address _to, uint256 _amount);

    modifier onlyValidVoterModifier(address _voter) {
        require(voters[_voter].voted == false && voters[_voter].weight > 0);
        _;
    }

    /// Create a new ballot with $(_numProposals) different proposals.
    constructor (uint8 _numProposals) Ballot(_numProposals) public {
    }

    // The keyword payable will allow the function to receive the ETH and keep the amount
    // Access the amount via msg.value
    // To deposit, simply send a valid value of ETH to the contract when calling this function
    function bribe(address _to, uint8 _proposal) payable onlyValidVoterModifier(_to) public {
        assert (_proposal < proposals.length);

        if(proposalVoterBribes[_proposal][_to][msg.sender] > 0) {
            proposalVoterBribes[_proposal][_to][msg.sender] += msg.value;
        } else {
            proposalVoterBribes[_proposal][_to][msg.sender] = msg.value;
        }

        emit BribeVoter(_proposal, msg.sender, _to, msg.value);
    }
}