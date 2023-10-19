//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    //errors
    error MoodNFT__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;
    mapping(uint256 => MOOD) private s_tokenIDtoMood;

    enum MOOD {
        HAPPY,
        SAD
    }

    constructor(string memory sadSVGImageUri, string memory happySVGImageUri) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSVGImageURI = sadSVGImageUri;
        s_happySVGImageURI = happySVGImageUri;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIDtoMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenID) public {
        //we want only the NFT owner to change the mood
        if (!_isApprovedOrOwner(msg.sender, tokenID)) {
            //This function comes from ERC721 contract
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIDtoMood[tokenID] == MOOD.HAPPY) {
            s_tokenIDtoMood[tokenID] = MOOD.SAD;
        } else {
            s_tokenIDtoMood[tokenID] = MOOD.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        // ERC721 contract also has a baseURI function so we need to override it
        return "data:application/json;base64,"; //in order to concat the beginning of the URI with the tokenURI
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIDtoMood[tokenId] == MOOD.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySVGImageURI;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSVGImageURI;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
