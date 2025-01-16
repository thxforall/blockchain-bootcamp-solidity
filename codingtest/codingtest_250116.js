import Web3 from "web3";
import dotenv from "dotenv";

dotenv.config();
const web3 = new Web3(process.env.INFURA_URL);

const privateKey = process.env.PRIVATE_KEY;
let account;
if (privateKey) {
  try {
    account = web3.eth.accounts.privateKeyToAccount(privateKey);
    web3.eth.accounts.wallet.add(account);
    console.log(`Using account: ${account.address}`);
  } catch (error) {
    console.error("Invalid Private Key:", error);
  }
} else {
  console.log("No PRIVATE_KEY found. Proceeding without an account.");
}

const UNISWAP_V3_POOL_ADDRESS = "0x1F98431c8aD98523631AE4a59f267346ea31F984";
const UNISWAP_V3_POOL_ABI = [
  {
    inputs: [
      { internalType: "address", name: "", type: "address" },
      { internalType: "address", name: "", type: "address" },
      { internalType: "uint24", name: "", type: "uint24" },
    ],
    name: "getPool",
    outputs: [{ internalType: "address", name: "", type: "address" }],
    stateMutability: "view",
    type: "function",
  },
];

const USDC_ADDRESS = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const WETH_ADDRESS = "0xC02aaA39b223FE8D0A0E5C4F27eAD9083C756Cc2";

const FEE = 3000;

async function getUniswapV3Pool() {
  const factory = new web3.eth.Contract(
    UNISWAP_V3_POOL_ABI,
    UNISWAP_V3_POOL_ADDRESS
  );
  const poolAddress = await factory.methods
    .getPool(USDC_ADDRESS, WETH_ADDRESS, FEE)
    .call();
  console.log(`Uniswap V3 Pool Address: ${poolAddress}`);
}

// 모든 환경 변수 로드 확인
console.log("현재 로드된 환경 변수:");
for (const [key, value] of Object.entries(process.env)) {
    console.log(`${key}: ${value}`);
}

getUniswapV3Pool();
