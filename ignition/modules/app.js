import dotenv from "dotenv";
import { Web3 } from "web3";

dotenv.config();

const web3 = new Web3(`${process.env.INFURA_WS}`);
const privateKey = process.env.PRIVATE_KEY;

const account = web3.eth.accounts.privateKeyToAccount(privateKey);
web3.eth.accounts.wallet.add(account);

async function getNFT() {
  const PudgyPenguins = "0xBd3531dA5CF5857e7CfAA92426877b022e612cf8";
  const walletAddress = "0xA67286D1051a789F9fAD1b9E18B43644F8786Cd3";

  try {
    const events = await web3.eth.getPastLogs({
      fromBlock: "earliest",
      toBlock: "latest",
      address: PudgyPenguins,
      topics: [
        web3.utils.sha3("Transfer(address,address,uint256)"),
        null,
        web3.utils.padLeft(walletAddress.toLowerCase(), 64),
      ],
    });

    console.log("거래 내역:");
    for (const event of events) {
      console.log(`
                트랜잭션 해시: ${event.transactionHash}
                블록 번호: ${event.blockNumber}
                토큰 ID: ${web3.utils.hexToNumber(event.topics[3])}
            `);
    }
  } catch (error) {
    console.error("Error:", error);
  }
}

getNFT();
