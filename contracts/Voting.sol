// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    Proposal[] public proposals;

    // Create a new proposal to call 'target' with 'data'
    function newProposal(address _target, bytes memory _data) external {
        proposals.push(Proposal(_target, _data, 0, 0));
    }

    // Vote on proposal #`_proposalId`, `_yes` for yes, `_no` for no
    function castVote(uint _proposalId, bool _yes) external {
        Proposal storage proposal = proposals[_proposalId];
        if (_yes) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }
    }
}
