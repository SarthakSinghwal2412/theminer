const main = async ()=> {
    const contractFactory = await hre.ethers.getContractFactory("Charity");
    const con = await contractFactory.deploy();
    await con.deployed();
  
    console.log("Contract deployed to address: ", con.address);
  
    let txn = await con.mint();
    await txn.wait();

    console.log("Minted NFT.");
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