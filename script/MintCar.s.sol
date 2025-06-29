// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/RWA_Car.sol";

/**
 * @title MintCarNFT
 * @notice Script to mint a sample RWA Car NFT on Fuji Testnet.
 */
contract MintCarNFT is Script {
// function run() external {
//     // Input the deployed RWA_Car contract address here
//     address deployedAddress = vm.envAddress("RWA_CAR_ADDRESS");
//     // Load deployed contract
//     RWA_Car rwaCar = RWA_Car(deployedAddress);
//     // Sample metadata URI (replace with real IPFS URI if needed)
//     string memory tokenURI = "ipfs://QmYourMetadataHashHere";
//     // Start broadcasting
//     vm.startBroadcast();
//     // Call the mint function
//     rwaCar.mintCarNFT(
//         "1HGCM82633A004352", // VIN
//         "Toyota", // Make
//         "Corolla XLE", // Trim
//         2018, // Year
//         50000, // Mileage
//         "White", // Exterior color
//         "Black", // Interior color
//         "FWD", // Drivetrain
//         "1.8L I4", // Engine
//         "Automatic", // Transmission
//         "Clean", // Sale doc
//         true, // Keys
//         20000 * 1e18, // Purchase Amount in wei (20k USD)
//         tokenURI // IPFS metadata URI
//     );
//     vm.stopBroadcast();
// }
}
