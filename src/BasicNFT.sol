//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIDtoURI;

    constructor() ERC721("Dogie", "Dog") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        // Allowing Owners to choose what heir tokens will look like
        s_tokenIDtoURI[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // return "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";
        return s_tokenIDtoURI[tokenId];
    }
}
