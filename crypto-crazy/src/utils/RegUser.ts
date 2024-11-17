// contract.js
import { JsonRpcProvider } from 'ethers/providers';
import { ethers } from 'ethers';
import RegisterUserAbi from '../../contracts/ABI/RegisterUser.json';
const contractAddress = '0xA522F6f6196B409d9113278a71D0c0B03639Fa52'; // Replace with the deployed contract address

const infuraApiKey = process.env.INFURA_API_KEY;
// if (!infuraApiKey) {
//   throw new Error('Infura API Key is missing!');
// }

export const getContract = async () => {
  try {
    // Initialize the provider with Infura
    const provider = new JsonRpcProvider(`https://mainnet.infura.io/v3/${infuraApiKey}`);
    
    // Create the contract instance
    const contract = new ethers.Contract(contractAddress, RegisterUserAbi.abi, provider);

    console.log('Contract initialized:', contract);
    return contract;
  } catch (error) {
    console.error('Error initializing contract:', error);
  }
};


export const generateOTP = async (identifier: string) => {
  try {
    const contract = await getContract();
    const tx = await contract?.generateOTP(identifier);
    const receipt = await tx.wait();
    console.log('OTP generated:', receipt);
  } catch (error) {
    console.error('Error generating OTP:', error);
  }
};
 

// Function to verify OTP
export const verifyOTP = async (identifier: string, otp: number) => {
    try {
      const contract = await getContract();
      const success = await contract?.verifyOTP(identifier, otp); // Call verifyOTP function in the contract
      console.log('OTP verification result for', identifier, ':', success);
      return success;
    } catch (error) {
      console.error('Error verifying OTP:', error);
      throw error;
    }
  };
  
  // Function to log in the user (generate OTP for login)
  export const loginUser = async (identifier: string) => {
    try {
      const contract = await getContract();
      const success = await contract?.loginUser(identifier); // Call loginUser function in the contract
      console.log('Login initiated for', identifier, ':', success);
      return success;
    } catch (error) {
      console.error('Error initiating login:', error);
      throw error;
    }
  };
  
  // Function to verify login OTP
  export const verifyLoginOTP = async (identifier: string, otp: number) => {
    try {
      const contract = await getContract();
      const success = await contract?.verifyLoginOTP(identifier, otp); // Call verifyLoginOTP function in the contract
      console.log('Login OTP verification result for', identifier, ':', success);
      return success;
    } catch (error) {
      console.error('Error verifying login OTP:', error);
      throw error;
    }
  };
  
  // Example function to check if a user is registered
  export const isUserRegistered = async (identifier: string) => {
    try {
      const contract = await getContract();
      const isRegistered = await contract?.isUserRegistered(identifier); // Call isUserRegistered function in the contract
      console.log('Is user registered for', identifier, ':', isRegistered);
      return isRegistered;
    } catch (error) {
      console.error('Error checking user registration:', error);
      throw error;
    }
  };

  // Function to connect to MetaMask and get the user's address

