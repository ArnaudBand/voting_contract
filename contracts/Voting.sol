// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {
      struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }
}