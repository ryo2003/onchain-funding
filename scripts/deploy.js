const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();
  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const fundPortalFactory = await hre.ethers.getContractFactory("FundPortal");
  const fundPortal = await fundPortalFactory.deploy();
  await fundPortal.deployed();

  console.log("FundPortal contract deployed to: ", fundPortal.address);
  console.log("FundPortal contract deployed by: ", deployer.address);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
