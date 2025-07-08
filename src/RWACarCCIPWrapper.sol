// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {CCIPSender} from "./CCIPSender.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/contracts/interfaces/IRouterClient.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RWA_Car} from "./RWA_Car.sol";

/**

@title RWACarCCIPWrapper

@dev Wraps the RWA_Car contract to allow locking NFTs and sending cross-chain unlock instructions via Chainlink CCIP.
*/
contract RWACarCCIPWrapper is CCIPSender, Ownable {
    RWA_Car public immutable rwaCar;

    constructor(address _router, address payable _rwaCar) CCIPSender(_router) {
        rwaCar = RWA_Car(_rwaCar);
    }

    // Mapping to track locked NFTs
    mapping(uint256 => bool) public isLocked;

    /// @notice Emitted when an NFT is locked for cross-chain transfer.
    /// @param tokenId The tokenId of the car NFT locked.
    /// @param destinationChainSelector The target chain selector.
    /// @param receiver The address of the destination receiver.
    /// @param messageId The message ID of the CCIP transmission.
    event CarNFTLocked(
        uint256 indexed tokenId,
        uint64 indexed destinationChainSelector,
        address receiver,
        bytes32 messageId
    );

    /// @notice Emitted when an NFT is unlocked.
    /// @param tokenId The tokenId of the car NFT unlocked.
    event CarNFTUnlocked(uint256 indexed tokenId);

    /**

    @notice Constructor for the wrapper contract.

    @param _router The address of the Chainlink CCIP Router.

    @param _rwaCar The address of the RWA_Car contract.
    */

    /**

    @notice Locks the NFT and initiates a CCIP message to the destination chain.

    @param destinationChainSelector The selector of the destination chain (e.g., Monad).

    @param tokenId The tokenId of the NFT to lock.

    @param receiver The address of the receiver contract on the destination chain.

    @return messageId The unique ID of the CCIP message.
    */
    function lockAndSend(
        uint64 destinationChainSelector,
        uint256 tokenId,
        address receiver
    ) external returns (bytes32 messageId) {
        require(rwaCar.ownerOf(tokenId) == msg.sender, "Not NFT owner");
        require(!isLocked[tokenId], "Already locked");

        // Transfer NFT to wrapper and lock
        rwaCar.transferFrom(msg.sender, address(this), tokenId);
        isLocked[tokenId] = true;

        // Prepare cross-chain message
        bytes memory data = abi.encode(tokenId, msg.sender);
        messageId = _ccipSend(destinationChainSelector, receiver, data);

        emit CarNFTLocked(
            tokenId,
            destinationChainSelector,
            receiver,
            messageId
        );
    }

    /**

    @notice Unlocks a previously locked NFT. This simulates a callback from CCIP receiver on Monad.

    @param tokenId The tokenId of the NFT to unlock.

    @param to The address to send the unlocked NFT to.
    */
    function unlock(uint256 tokenId, address to) external onlyOwner {
        require(isLocked[tokenId], "NFT not locked");
        isLocked[tokenId] = false;
        rwaCar.transferFrom(address(this), to, tokenId);

        emit CarNFTUnlocked(tokenId);
    }

    /**

    @notice Returns whether a token is locked.

    @param tokenId The tokenId to query.

    @return True if locked, false otherwise.
    */
    function isTokenLocked(uint256 tokenId) external view returns (bool) {
        return isLocked[tokenId];
    }
}
