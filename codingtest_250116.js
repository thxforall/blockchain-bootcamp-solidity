import Web3 from 'web3';
import dotenv from 'dotenv';

dotenv.config();

const web3 = new Web3(process.env.INFURA_URL);

// private key는 반드시 '0x'로 시작하는 64자리 16진수 문자열이어야 합니다
const privateKey = process.env.PRIVATE_KEY;
if (!privateKey?.startsWith('0x')) {
    throw new Error('Private key must start with 0x');
}

const account = web3.eth.accounts.privateKeyToAccount(privateKey); 