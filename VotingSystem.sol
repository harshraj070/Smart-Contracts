// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract VotingSystem {

    struct Voter {
        bool hasVoted;
        uint vote;
        uint weight;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    function addCandidate(string memory _name) public {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
    }

    function registerVoter(address _voter, uint _weight) public {
        require(!voters[_voter].hasVoted, "Voter has already registered.");
        voters[_voter].weight = _weight;
    }

    function vote(uint _candidateIndex) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        require(sender.weight > 0, "Has no right to vote.");

        sender.hasVoted = true;
        sender.vote = _candidateIndex;
        candidates[_candidateIndex].voteCount += sender.weight;
    }

    function getTotalVotes() public view returns (uint) {
        uint totalVotes;
        for (uint i = 0; i < candidates.length; i++) {
            totalVotes += candidates[i].voteCount;
        }
        return totalVotes;
    }

    function getCandidate(uint _candidateIndex) public view returns (string memory, uint) {
        Candidate storage candidate = candidates[_candidateIndex];
        return (candidate.name, candidate.voteCount);
    }

    function hasVoted(address _voter) public view returns (bool) {
        return voters[_voter].hasVoted;
    }

    function resetVotes() public {
        for (uint i = 0; i < candidates.length; i++) {
            candidates[i].voteCount = 0;
        }
        for (address voterAddress in voters) {
            voters[voterAddress].hasVoted = false;
        }
    }
}
