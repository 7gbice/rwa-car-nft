// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Client} from "@chainlink/contracts-ccip/contracts/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/contracts/interfaces/IRouterClient.sol";

abstract contract CCIPSender {
    IRouterClient public immutable router;

    constructor(address _router) {
        router = IRouterClient(_router);
    }

    function _ccipSend(
        uint64 destinationChainSelector,
        address receiver,
        bytes memory data
    ) internal returns (bytes32 messageId) {
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](0);

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: data,
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 200000})
            ),
            feeToken: address(0)
        });

        uint256 fee = router.getFee(destinationChainSelector, message);
        require(address(this).balance >= fee, "Insufficient fee");

        messageId = router.ccipSend{value: fee}(
            destinationChainSelector,
            message
        );
    }

    receive() external payable {}
}
