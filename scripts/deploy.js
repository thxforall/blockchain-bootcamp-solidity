const hre = require("hardhat");

async function main() {
  console.log("Deploying AToken contract...");

  const AToken = await hre.ethers.getContractFactory("AToken");
  const atoken = await AToken.deploy();

  await atoken.waitForDeployment();

  console.log("AToken deployed to:", await atoken.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}); 