pragma solidity ^0.4.17;

import "./ballot.sol";

contract CorruptBallot is Ballot {


    /// Create a new ballot with $(_numProposals) different proposals.
    constructor (uint8 _numProposals) Ballot(_numProposals) public {
    }
}