// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate { string name; uint256 voteCount; }
    struct Voter { bool authorized; bool voted; uint256 voteIndex; }
    Candidate[] public candidates;
    mapping(address => Voter) public voters;
    address public chairperson;
    event VoterAuthorized(address indexed voter);
    event VoteCast(address indexed voter, uint256 indexed candidateIndex);
    modifier onlyChairperson() { require(msg.sender == chairperson, "Only chairperson"); _; }
    constructor(string[] memory candidateNames) { require(candidateNames.length > 0, "No candidates"); chairperson = msg.sender; for(uint i; i<candidateNames.length; i++) candidates.push(Candidate(candidateNames[i], 0)); }
    function authorize(address voter) external onlyChairperson { require(!voters[voter].authorized, "Already authorized"); voters[voter].authorized = true; emit VoterAuthorized(voter); }
    function vote(uint256 candidateIndex) external { Voter storage voter = voters[msg.sender]; require(voter.authorized, "Not authorized"); require(!voter.voted, "Already voted"); require(candidateIndex < candidates.length, "Invalid candidate"); voter.voted = true; voter.voteIndex = candidateIndex; candidates[candidateIndex].voteCount++; emit VoteCast(msg.sender, candidateIndex); }
    function totalVotes(uint256 candidateIndex) external view returns (uint256) { require(candidateIndex < candidates.length, "Invalid candidate"); return candidates[candidateIndex].voteCount; }
    function winnerName() external view returns (string memory) { uint winner; for(uint i=1; i<candidates.length; i++) if(candidates[i].voteCount > candidates[winner].voteCount) winner=i; return candidates[winner].name; }
}
