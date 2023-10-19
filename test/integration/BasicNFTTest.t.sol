//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName))); // We can't use == for string memory type. So we are converting the string to bytes and then getting the hash and then coparing the hash
    }

    function testCanMintAndhaveABalance() public {
        vm.prank(USER);
        basicNFT.mintNft(PUG);
        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNFT.tokenURI(0))) == keccak256(abi.encodePacked(PUG)));
    }
}
