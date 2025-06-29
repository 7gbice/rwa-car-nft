# forge script script/DeployRWA_Car.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_API_KEY

[⠒] Compiling...
No files changed, compilation skipped
Script ran successfully.

## Setting up 1 EVM.

==========================

Chain 11155111

Estimated gas price: 22.938945196 gwei

Estimated total gas used for script: 3232407

Estimated amount required: 0.074148007024166772 ETH

==========================

##### sepolia

✅ [Success] Hash: 0x265339c21dfe4d453978f331ed60e42b0b7d52253983090acee2c75127e27412
Contract Address: 0xCc09499dd7672FA063568A23454ED6906049165C
Block: 8631037
Paid: 0.026139919428117624 ETH (2486467 gas \* 10.512876072 gwei)

✅ Sequence #1 on sepolia | Total Paid: 0.026139919428117624 ETH (2486467 gas \* avg 10.512876072 gwei)

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

##

Start verification for (1) contracts
Start verifying contract `0xCc09499dd7672FA063568A23454ED6906049165C` deployed on sepolia
EVM version: cancun
Compiler version: 0.8.30
Optimizations: 200

Submitting verification for [src/RWA_Car.sol:RWA_Car] 0xCc09499dd7672FA063568A23454ED6906049165C.
Submitted contract for verification:
Response: `OK`
GUID: `pyh1bnugtgunujiqd1rbzehyutfbpmktgccwdymul1xtnindhg`
URL: https://sepolia.etherscan.io/address/0xcc09499dd7672fa063568a23454ed6906049165c
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Warning: Verification is still pending...; waiting 15 seconds before trying again (7 tries remaining)
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (1) contracts were verified!

Transactions saved to: /home/ariecode/audit_contracts/practice/solidity course/hotel/broadcast/DeployRWA_Car.s.sol/11155111/run-latest.json

Sensitive values saved to: /home/ariecode/audit_contracts/practice/solidity course/hotel/cache/DeployRWA_Car.s.sol/11155111/run-latest.json

# ariecode@7gbice:~/audit_contracts/practice/solidity course/hotel$ forge script script/DeployRWA_Car.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --account mine-272-account2 --sender 0xea13fb2F71daCDA3da7536698D5FE6405466A897 --verify --etherscan-api-key $ETHERSCAN_API_KEY
