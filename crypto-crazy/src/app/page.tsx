"use client";

declare global {
  interface Window {
    ethereum: any;
  }
}

import React, { useState } from 'react';
import { generateOTP, verifyOTP, getContract } from '../utils/RegUser';
import { ethers } from 'ethers';

import { JsonRpcProvider, Provider } from 'ethers/providers';


const Home = () => {
  const [identifier, setIdentifier] = useState('');
  const [otp, setOtp] = useState('');
  const [userAddress, setUserAddress] = useState('');
  const [contract, setContract] = useState<ethers.Contract | null>(null);
  const connectMetaMask: any = async () => {
    try {
      // Request account access if needed
      await window.ethereum.request({ method: 'eth_requestAccounts' });
  
      // Create a new Web3Provider instance
      const provider = new JsonRpcProvider(window.ethereum);
  
      // Get the signer from the provider (this represents the user's wallet)
      const signer = provider.getSigner();
  
      console.log('Signer:', signer);
  
      // Now you can interact with your contract using the signer
      // For example, calling contract functions
    } catch (error) {
      console.error('Error connecting to MetaMask:', error);
    }
  };
  


  const handleConnectMetaMask = async () => {
    try {
      const address = await connectMetaMask();
      setUserAddress(address);
      alert('Connected to MetaMask!');
    } catch (error) {
      console.error('Error connecting to MetaMask:', error);
      alert('Failed to connect to MetaMask.');
    }
  };

  const handleGenerateOTP = async () => {
    try {
      const txHash = await generateOTP(identifier);
      console.log('Transaction Hash:', txHash);
    } catch (error) {
      console.error('Error generating OTP:', error);
    }
  };

  const handleVerifyOTP = async () => {
    try {
      const result = await verifyOTP(identifier, parseInt(otp));
      if (result) {
        alert('OTP verified successfully!');
      } else {
        alert('Invalid OTP!');
      }
    } catch (error) {
      console.error('Error verifying OTP:', error);
    }
  };

  return (
    <div>
      <h1>Blockchain-based User Registration</h1>
      {userAddress && <p>Connected as: {userAddress}</p>}
      <button onClick={handleConnectMetaMask}>Connect MetaMask</button>
      <input 
        type="text" 
        value={identifier} 
        onChange={(e) => setIdentifier(e.target.value)} 
        placeholder="Enter email or phone number" 
      />
      <input 
        type="text" 
        value={otp} 
        onChange={(e) => setOtp(e.target.value)} 
        placeholder="Enter OTP" 
      />
      <button onClick={handleGenerateOTP}>Generate OTP</button>
      <button onClick={handleVerifyOTP}>Verify OTP</button>
    </div>
  );
};

export default Home;
