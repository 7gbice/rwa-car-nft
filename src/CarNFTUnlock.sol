// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts-ccip/contracts/applications/CCIPReceiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Client} from "@chainlink/contracts-ccip/contracts/libraries/Client.sol";

/**
 * @title ICarNFT
 * @notice Interface for the bridged car NFT with minting capability.
 */
interface ICarNFT is IERC721 {
    function mintFromBridge(address to, uint256 tokenId) external;
}

/**
 * @title CarNFTUnlock
 * @notice Receiver contract on the destination chain to mint unlocked car NFTs via CCIP.
 */
contract CarNFTUnlock is CCIPReceiver, Ownable {
    ICarNFT public carNFT;

    constructor(address _carNFT, address _router) CCIPReceiver(_router) {
        carNFT = ICarNFT(_carNFT);
    }

    /**
     * @dev Handles the CCIP message to mint the NFT to the recipient.
     * @param message Encoded (tokenId, recipient) data.
     */
    // function _ccipReceive(bytes memory message) internal override {
    //     (uint256 tokenId, address recipient) = abi.decode(
    //         message,
    //         (uint256, address)
    //     );
    //     carNFT.mintFromBridge(recipient, tokenId);
    // }

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        (uint256 tokenId, address recipient) = abi.decode(
            message.data,
            (uint256, address)
        );
        carNFT.mintFromBridge(recipient, tokenId);
    }
}
