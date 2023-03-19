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

  // Test the sendEther function
  const recipient = "0x3dc588F96233D972A954cf9f72750977c4090575";
  const amount = ethers.utils.parseEther("0.01");

  await fundPortal.sendEther(recipient, { value: amount, gasLimit: 100000 });

  console.log("Ether sent to:", recipient, amount);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
