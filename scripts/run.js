const { ethers } = require("hardhat");

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const fundContractFactory = await hre.ethers.getContractFactory("FundPortal");
  const fundContract = await fundContractFactory.deploy();
  const fundPortal = await fundContract.deployed();

  console.log("Contract deployed to:", fundPortal.address);
  console.log("Contract deployed by:", owner.address);

  const campaignCount = await fundPortal.getCampaignCount();
  console.log("Campaign count:", campaignCount.toNumber());

  console.log("Owner:", owner);

  await fundPortal.createCampaign(
    ethers.utils.parseEther("10"), // funding goal of 10 ether
    Math.floor(Date.now() / 1000) + 3600, // deadline 1 hour from now
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4" // beneficiary address
  );

  const allCampaigns = await fundPortal.getAllCampaigns();
  console.log("All campaigns:", allCampaigns);

  const campaignInfo = await fundPortal.getCampaignInfo(0);
  console.log("Campaign info:", campaignInfo);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
