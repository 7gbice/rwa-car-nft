// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/RWA_Car.sol";

/**
 * @title Simulate RWA Car NFT Sale
 * @notice Lists a car NFT and simulates buying from another wallet on Fuji testnet
 */
contract SimulateTrade is Script {
// RWA_Car public rwa;
// address public buyer;
// address public seller;
// uint256 public price = 1 ether; // Simulated price
// uint256 public tokenId = 0; // Token ID to list/sell
// function setUp() public {
//     rwa = RWA_Car(vm.envAddress("RWA_CAR_ADDRESS")); // Deployed contract address
//     buyer = vm.envAddress("BUYER_ADDRESS");
//     seller = vm.envAddress("SELLER_ADDRESS");
// }
// function run() public {
//     uint256 sellerKey = vm.envUint("SELLER_PRIVATE_KEY");
//     uint256 buyerKey = vm.envUint("BUYER_PRIVATE_KEY");
//     vm.startBroadcast(sellerKey);
//     /// 📝 Log seller balance before
//     uint256 sellerBalanceBefore = seller.balance;
//     console.log("Seller balance before: %s", sellerBalanceBefore);
//     /// 📢 List car for sale
//     rwa.listCarForSale(tokenId, price);
//     console.log("Listed car #%s for sale at %s wei", tokenId, price);
//     vm.stopBroadcast();
//     vm.startBroadcast(buyerKey);
//     /// 📝 Log buyer balance before
//     uint256 buyerBalanceBefore = buyer.balance;
//     console.log("Buyer balance before: %s", buyerBalanceBefore);
//     /// 💸 Buy the car
//     rwa.buyCar{value: price}(tokenId);
//     console.log("Buyer purchased car #%s", tokenId);
//     vm.stopBroadcast();
//     /// ✅ Verify results
//     address newOwner = rwa.ownerOf(tokenId);
//     console.log("New owner of token #%s: %s", tokenId, newOwner);
//     require(newOwner == buyer, "Ownership not transferred");
//     (, uint256 currentPrice) = rwa.cars(tokenId);
//     console.log("Car current price after sale: %s", currentPrice);
//     require(currentPrice == 0, "Price not reset");
//     /// 💰 Final balance checks
//     console.log("Seller balance after: %s", seller.balance);
//     console.log("Buyer balance after: %s", buyer.balance);
// }
}
