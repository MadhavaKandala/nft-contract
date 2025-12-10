const { expect } = require("chai");

describe("NftCollection", function () {
  let nftCollection;
  let owner, addr1, addr2;
  const NAME = "TestNFT";
  const SYMBOL = "TNFT";
  const MAX_SUPPLY = 1000;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    const NftCollection = await ethers.getContractFactory("NftCollection");
    nftCollection = await NftCollection.deploy(NAME, SYMBOL, MAX_SUPPLY);
  });

  describe("Initialization", function () {
    it("Should initialize with correct values", async function () {
      expect(await nftCollection.name()).to.equal(NAME);
      expect(await nftCollection.symbol()).to.equal(SYMBOL);
      expect(await nftCollection.maxSupply()).to.equal(MAX_SUPPLY);
      expect(await nftCollection.totalSupply()).to.equal(0);
    });
  });

  describe("Minting", function () {
    it("Should mint tokens correctly", async function () {
      await nftCollection.safeMint(addr1.address, 1);
      expect(await nftCollection.balanceOf(addr1.address)).to.equal(1);
      expect(await nftCollection.ownerOf(1)).to.equal(addr1.address);
    });

    it("Should not mint to zero address", async function () {
      await expect(nftCollection.safeMint(ethers.ZeroAddress, 1)).to.be.revertedWith(
        "Cannot mint to zero address"
      );
    });

    it("Should not mint same token twice", async function () {
      await nftCollection.safeMint(addr1.address, 1);
      await expect(nftCollection.safeMint(addr2.address, 1)).to.be.revertedWith(
        "Token already exists"
      );
    });

    it("Should emit Transfer event on mint", async function () {
      await expect(nftCollection.safeMint(addr1.address, 1))
        .to.emit(nftCollection, "Transfer")
        .withArgs(ethers.ZeroAddress, addr1.address, 1);
    });
  });

  describe("Transfers", function () {
    beforeEach(async function () {
      await nftCollection.safeMint(addr1.address, 1);
    });

    it("Should transfer tokens", async function () {
      await nftCollection.connect(addr1).transfer(addr2.address, 1);
      expect(await nftCollection.ownerOf(1)).to.equal(addr2.address);
      expect(await nftCollection.balanceOf(addr1.address)).to.equal(0);
      expect(await nftCollection.balanceOf(addr2.address)).to.equal(1);
    });

    it("Should revert on non-existent token", async function () {
      await expect(nftCollection.ownerOf(999)).to.be.revertedWith("Token does not exist");
    });
  });

  describe("Approvals", function () {
    beforeEach(async function () {
      await nftCollection.safeMint(addr1.address, 1);
    });

    it("Should approve token transfer", async function () {
      await nftCollection.connect(addr1).approve(addr2.address, 1);
      expect(await nftCollection.getApproved(1)).to.equal(addr2.address);
    });

    it("Should transfer approved token", async function () {
      await nftCollection.connect(addr1).approve(addr2.address, 1);
      await nftCollection.connect(addr2).transferFrom(addr1.address, addr2.address, 1);
      expect(await nftCollection.ownerOf(1)).to.equal(addr2.address);
    });

    it("Should set approval for all", async function () {
      await nftCollection.connect(addr1).setApprovalForAll(addr2.address, true);
      expect(await nftCollection.isApprovedForAll(addr1.address, addr2.address)).to.be.true;
    });

    it("Should emit Approval event", async function () {
      await expect(nftCollection.connect(addr1).approve(addr2.address, 1))
        .to.emit(nftCollection, "Approval")
        .withArgs(addr1.address, addr2.address, 1);
    });
  });

  describe("Pause/Unpause", function () {
    it("Should pause and unpause minting", async function () {
      await nftCollection.pauseMinting();
      await expect(nftCollection.safeMint(addr1.address, 1)).to.be.revertedWith(
        "Contract is paused"
      );
      await nftCollection.unpauseMinting();
      await nftCollection.safeMint(addr1.address, 1);
      expect(await nftCollection.balanceOf(addr1.address)).to.equal(1);
    });
  });

  describe("Metadata", function () {
    it("Should return correct tokenURI", async function () {
      await nftCollection.safeMint(addr1.address, 1);
      const uri = await nftCollection.tokenURI(1);
      expect(uri).to.include("1.json");
    });
  });
});
