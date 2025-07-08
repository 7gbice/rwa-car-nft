import React from "react";
import CarCard from "./components/CarCard";
import MintForm from "./components/MintForm";
import TransferWidget from "./components/TransferWidget";
import { useEffect, useState } from "react";
import { ethers } from "ethers";
import { getCarNFTContract } from "./lib/contract";
import WalletBar from "./components/WalletBar";
import useWallet from "./hooks/useWallet";

function App() {
  const { address, provider, signer } = useWallet();

  const mockCar = {
    vin: "1HGCM82633A123456",
    mileage: "52000",
    engine: "V6 Turbo",
    color: "Midnight Blue",
    image: "https://via.placeholder.com/300x200",
    value: "14,300"
  };

  const handleMint = async (form: {
    vin: string;
    mileage: string;
    engine: string;
    color: string;
    image: string;
  }) => {
    if (!signer) return console.warn("No wallet connected");
    try {
      const contract = getCarNFTContract(signer);
      const tx = await contract.mintCarNFT(
        form.vin,
        form.mileage,
        form.engine,
        form.color,
        form.image
      );
      await tx.wait();
      console.log("✅ Car NFT Minted!");
    } catch (err) {
      console.error("Minting failed:", err);
    }
  };

  const handleTransfer = async ({
    chainSelector,
    tokenId,
    receiver
  }: {
    chainSelector: string;
    tokenId: string;
    receiver: string;
  }) => {
    if (!signer) return console.warn("No wallet connected");
    try {
      const contract = getCarNFTContract(signer);
      const tx = await contract.lockAndSend(
        chainSelector,
        tokenId,
        receiver
      );
      await tx.wait();
      console.log("✅ Car NFT Sent Cross-Chain!");
    } catch (err) {
      console.error("Transfer failed:", err);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-tr from-gray-100 via-blue-100 to-purple-200 py-12 px-6">
      <WalletBar address={address} />
      <h1 className="text-4xl font-bold text-center mb-12 text-gray-800">
        🚗 RWA CarNFT Dashboard
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-12 mb-16">
        <MintForm onSubmit={handleMint} />
        <TransferWidget onTransfer={handleTransfer} />
      </div>

      <h2 className="text-2xl font-semibold mb-6 text-gray-700">Your Garage</h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
        <CarCard {...mockCar} />
      </div>
    </div>
  );
}



export default App;
