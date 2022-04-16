const main = async ()=> {

  const [owner, randomPerson, thirdPerson] = await hre.ethers.getSigners();

  const contractFactory = await hre.ethers.getContractFactory("Charity");
  const con = await contractFactory.deploy(randomPerson.address, thirdPerson.address);
  await con.deployed();

  console.log("Contract deployed to address: ", con.address);
  let balance = await hre.ethers.provider.getBalance(thirdPerson.address);
  console.log(hre.ethers.utils.formatEther(balance));
  let txn = await con.mint("https://jsonkeeper.com/b/6G8O", "charity2", {value: hre.ethers.utils.parseEther("0.05")});
  await txn.wait();
  console.log("minted.");
  console.log('/------------------------------------------------------------------------------/');
  balance = await hre.ethers.provider.getBalance(thirdPerson.address);
  console.log(hre.ethers.utils.formatEther(balance));

  txn = await con.withdraw();
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
};

runMain();