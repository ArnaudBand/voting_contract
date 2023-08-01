// File: test/VotingTest.js
const { expect } = require("chai");

describe("Voting", function () {
  let Voting;
  let voting;
  let owner;
  let member1;
  let member2;

  beforeEach(async () => {
    [owner, member1, member2] = await ethers.getSigners();
    Voting = await ethers.getContractFactory("Voting");
    voting = await Voting.deploy([owner.address, member1.address, member2.address]);
    await voting.deployed();
  });

  it("should create a new proposal and vote on it", async function () {
    await voting.newProposal(owner.address, "0x");
    const proposalId = 0;

    const voteCountBefore = await voting.proposals(proposalId, "yesCount");
    expect(voteCountBefore).to.equal(0);

    await voting.castVote(proposalId, true);

    const voteCountAfter = await voting.proposals(proposalId, "yesCount");
    expect(voteCountAfter).to.equal(1);
  });

  it("should execute the proposal when vote threshold is reached", async function () {
    await voting.newProposal(owner.address, "0x");
    const proposalId = 0;

    for (let i = 0; i < 10; i++) {
      await voting.connect(member1).castVote(proposalId, true);
    }

    const proposalBefore = await voting.proposals(proposalId);
    expect(proposalBefore.executed).to.be.false;

    await voting.connect(member2).castVote(proposalId, true);

    const proposalAfter = await voting.proposals(proposalId);
    expect(proposalAfter.executed).to.be.true;
  });
});
