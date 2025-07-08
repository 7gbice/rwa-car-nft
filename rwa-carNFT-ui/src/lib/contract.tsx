import { ethers } from "ethers";
import abi from "./abi.json"; // Drop your ABI JSON here

const CONTRACT_ADDRESS = "0xYourCarNFTContractAddress"; // Replace with actual deployed address

export function getCarNFTContract(signer: ethers.Signer) {
  return new ethers.Contract(CONTRACT_ADDRESS, abi, signer);
}
