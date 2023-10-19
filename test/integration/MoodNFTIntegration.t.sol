//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";

contract MoodNFTIntegration is Test {
    MoodNFT public moodNFT;
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PScwIDAgMjAwIDIwMCcgd2lkdGg9JzQwMCcgaGVpZ2h0PSc0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMTAwJyBjeT0nMTAwJyBmaWxsPSd5ZWxsb3cnIHI9Jzc4JyBzdHJva2U9J2JsYWNrJyBzdHJva2Utd2lkdGg9JzMnLz48ZyBjbGFzcz0nZXllcyc+PGNpcmNsZSBjeD0nNjEnIGN5PSc4Micgcj0nMTInLz48Y2lyY2xlIGN4PScxMjcnIGN5PSc4Micgcj0nMTInLz48L2c+PHBhdGggZD0nbTEzNi44MSAxMTYuNTNjLjY5IDI2LjE3LTY0LjExIDQyLTgxLjUyLS43Mycgc3R5bGU9J2ZpbGw6bm9uZTsgc3Ryb2tlOiBibGFjazsgc3Ryb2tlLXdpZHRoOiAzOycvPjwvc3ZnPg==";
    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiBmaWxsPSIjMjE5NkYzIiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+PGcgY2xhc3M9ImV5ZXMiPjxlbGxpcHNlIGN4PSI3NSIgY3k9IjgwIiByeD0iMTUiIHJ5PSIxMCIgZmlsbD0id2hpdGUiIC8+PGVsbGlwc2UgY3g9IjExNSIgY3k9IjgwIiByeD0iMTUiIHJ5PSIxMCIgZmlsbD0id2hpdGUiIC8+PGVsbGlwc2UgY3g9Ijc1IiBjeT0iODAiIHJ4PSI1IiByeT0iMTAiIGZpbGw9ImJsYWNrIiAvPjxlbGxpcHNlIGN4PSIxMTUiIGN5PSI4MCIgcng9IjUiIHJ5PSIxMCIgZmlsbD0iYmxhY2siIC8+PC9nPjxnIGNsYXNzPSJleWVicm93cyI+PHBhdGggZD0iTTY1IDY1IFE3NSA1NSwgODUgNjUiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTpibGFjazsgc3Ryb2tlLXdpZHRoOjU7IiAvPjxwYXRoIGQ9Ik0xMDAgNjUgUTExMCA1NSwgMTIwIDY1IiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6YmxhY2s7IHN0cm9rZS13aWR0aDo1OyIgLz48L2c+PHBhdGggZD0iTTcwIDE0MCBRMTAwIDEyMCwgMTMwIDE0MCIgc3R5bGU9ImZpbGw6bm9uZTsgc3Ryb2tlOmJsYWNrOyBzdHJva2Utd2lkdGg6MzsiIC8+PC9zdmc+";
    string public constant SAD_SVG_URI = "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdhR1ZwWjJoMFBTSTBNREFpSUhodGJHNXpQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh5TURBd0wzTjJaeUkrUEdOcGNtTnNaU0JqZUQwaU1UQXdJaUJqZVQwaU1UQXdJaUJtYVd4c1BTSWpNakU1TmtZeklpQnlQU0kzT0NJZ2MzUnliMnRsUFNKaWJHRmpheUlnYzNSeWIydGxMWGRwWkhSb1BTSXpJaTgrUEdjZ1kyeGhjM005SW1WNVpYTWlQanhsYkd4cGNITmxJR040UFNJM05TSWdZM2s5SWpnd0lpQnllRDBpTVRVaUlISjVQU0l4TUNJZ1ptbHNiRDBpZDJocGRHVWlJQzgrUEdWc2JHbHdjMlVnWTNnOUlqRXhOU0lnWTNrOUlqZ3dJaUJ5ZUQwaU1UVWlJSEo1UFNJeE1DSWdabWxzYkQwaWQyaHBkR1VpSUM4K1BHVnNiR2x3YzJVZ1kzZzlJamMxSWlCamVUMGlPREFpSUhKNFBTSTFJaUJ5ZVQwaU1UQWlJR1pwYkd3OUltSnNZV05ySWlBdlBqeGxiR3hwY0hObElHTjRQU0l4TVRVaUlHTjVQU0k0TUNJZ2NuZzlJalVpSUhKNVBTSXhNQ0lnWm1sc2JEMGlZbXhoWTJzaUlDOCtQQzluUGp4bklHTnNZWE56UFNKbGVXVmljbTkzY3lJK1BIQmhkR2dnWkQwaVRUWTFJRFkxSUZFM05TQTFOU3dnT0RVZ05qVWlJSE4wZVd4bFBTSm1hV3hzT201dmJtVTdJSE4wY205clpUcGliR0ZqYXpzZ2MzUnliMnRsTFhkcFpIUm9PalU3SWlBdlBqeHdZWFJvSUdROUlrMHhNREFnTmpVZ1VURXhNQ0ExTlN3Z01USXdJRFkxSWlCemRIbHNaVDBpWm1sc2JEcHViMjVsT3lCemRISnZhMlU2WW14aFkyczdJSE4wY205clpTMTNhV1IwYURvMU95SWdMejQ4TDJjK1BIQmhkR2dnWkQwaVRUY3dJREUwTUNCUk1UQXdJREV5TUN3Z01UTXdJREUwTUNJZ2MzUjViR1U5SW1acGJHdzZibTl1WlRzZ2MzUnliMnRsT21Kc1lXTnJPeUJ6ZEhKdmEyVXRkMmxrZEdnNk16c2lJQzgrUEM5emRtYysifQ==";
    address USER = makeAddr("USER");
    DeployMoodNFT public deployer;

    function setUp() public {
        deployer = new DeployMoodNFT();
        moodNFT = deployer.run();
    }
    /*without vm.prank, we are minting the NFT to the test contract and this test contract doesnt have a receive function
    Openzeppelin put in some code so that people won't tranfer NFTs to contracts that can't transfer them or do anything
    */

    function testViewTokenUriIntegration() public {
        vm.prank(USER);
        moodNFT.mintNFT();
        console.log(moodNFT.tokenURI(0));
    }

    function testflipTokentoSad() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        vm.prank(USER);
        moodNFT.flipMood(0);
        console.log(moodNFT.tokenURI(0));
        console.log(SAD_SVG_IMAGE_URI);

        assertEq(keccak256(abi.encodePacked(moodNFT.tokenURI(0))),keccak256(abi.encodePacked(SAD_SVG_URI)));
    }
}
