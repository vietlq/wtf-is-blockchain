pragma solidity ^0.4.17;

contract Score {

uint myscore;

// Typical pattern to have owner address, onlyOwner
address owner;

modifier onlyOwner() {
    if (msg.sender == owner) {
        _;
    }
}

// Events are cheap way to share information
event ScoreSet(uint);

constructor() public {
    // Typical pattern to have owner address, onlyOwner
    owner = msg.sender;

}

function getScore() view public returns (uint) {
    return myscore;
}

// public = internal + external

function setScore(uint _newScore) public onlyOwner {
    myscore = _newScore;
    // Emit log for external programs to monitor and react
    emit ScoreSet(_newScore);
}

}