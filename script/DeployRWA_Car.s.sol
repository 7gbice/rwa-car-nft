// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";
import {RWA_Car} from "../src/RWA_Car.sol";

// contract DeployRWA_Car is Script {
//     function setUp() public {}

//     function run() public {
//         vm.startBroadcast();
//         RWA_Car rwaCar = new RWA_Car();
//         vm.stopBroadcast();
//         // return RWA_Car();
//     }
// }

/**
 * @title DeployRWA_Car
 * @notice Foundry script to deploy the RWA_Car contract using a keystore wallet on Fuji testnet.
 */
contract DeployRWA_Car is Script {
    function run() external {
        // Begin broadcasting from the default wallet (will be overridden by CLI args)
        vm.startBroadcast();

        // Deploy the contract
        RWA_Car rwaCar = new RWA_Car();

        console.log("RWA_Car deployed to:", address(rwaCar));
        console.log("Deployed at:", address(rwaCar));
        console.log("Deployer:", msg.sender);

        vm.stopBroadcast();
    }
}
