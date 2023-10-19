//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract MintBasicNFT is Script {
    string public constant PUG = "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8?filename=pug.png";

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        //address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}
