//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";

contract DeployMoodNFTTest is Test {
    DeployMoodNFT public deployer;

    function setUp() public {
        deployer = new DeployMoodNFT();
    }

    function testConvertSVGtoURI() public  {
        string memory expectedURI ="data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PScwIDAgMjAwIDIwMCcgd2lkdGg9JzQwMCcgaGVpZ2h0PSc0MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMTAwJyBjeT0nMTAwJyBmaWxsPSd5ZWxsb3cnIHI9Jzc4JyBzdHJva2U9J2JsYWNrJyBzdHJva2Utd2lkdGg9JzMnLz48ZyBjbGFzcz0nZXllcyc+PGNpcmNsZSBjeD0nNjEnIGN5PSc4Micgcj0nMTInLz48Y2lyY2xlIGN4PScxMjcnIGN5PSc4Micgcj0nMTInLz48L2c+PHBhdGggZD0nbTEzNi44MSAxMTYuNTNjLjY5IDI2LjE3LTY0LjExIDQyLTgxLjUyLS43Mycgc3R5bGU9J2ZpbGw6bm9uZTsgc3Ryb2tlOiBibGFjazsgc3Ryb2tlLXdpZHRoOiAzOycvPjwvc3ZnPg==";
        string memory svg =
            "<svg viewBox='0 0 200 200' width='400' height='400' xmlns='http://www.w3.org/2000/svg'><circle cx='100' cy='100' fill='yellow' r='78' stroke='black' stroke-width='3'/><g class='eyes'><circle cx='61' cy='82' r='12'/><circle cx='127' cy='82' r='12'/></g><path d='m136.81 116.53c.69 26.17-64.11 42-81.52-.73' style='fill:none; stroke: black; stroke-width: 3;'/></svg>";
        string memory actualURI = deployer.svgToImageURI(svg);
        console.log(expectedURI);
        console.log(actualURI);

        assertEq(keccak256(abi.encodePacked(expectedURI)),keccak256(abi.encodePacked(actualURI)));
    }
}
