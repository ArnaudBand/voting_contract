// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {

    enum VoteStates{ Yes, No, Absent }
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        mapping(address => VoteStates) votes;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint);
    event VoteCast(uint, address);

    // Create a new proposal to call 'target' with 'data'
    function newProposal(address _target, bytes memory _data) external {
        emit ProposalCreated(proposals.length);
        Proposal storage proposal = proposals.push();
        proposal.target = _target;
        proposal.data = _data;
    }

    // Vote on proposal #`_proposalId`, `_yes` for yes, `_no` for no
    function castVote(uint _proposalId, bool _yes) external {
        Proposal storage proposal = proposals[_proposalId];

        if(proposal.votes[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        } else if(proposal.votes[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        // Check if the proposal is still open
        if (_yes) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }

        proposal.votes[msg.sender] = _yes ? VoteStates.Yes : VoteStates.No;
        emit VoteCast(_proposalId, msg.sender);
    }
}
