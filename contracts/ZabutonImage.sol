// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IZabutonImage.sol";

contract ZabutonImage is IZabutonImage, Ownable {
    string svgHeader =
        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1080 1080" style="background-color: black;">';

    string zabuton =
        '<defs><g id="a" ><path d="m646 589-87 8-28-11-57 14 67-3 104 8 122-6z" style="fill:#3c1d84"/><path d="m746 544-29 20-7-21-64 5-39-8-74 18-10-12-75 7-105-13-124 18-7-7-69 9 79 31 202 12 50-3 57-14 28 11 87-8 121 10 100-20 71-17z" style="fill:#5c32a3"/><path d="m540 487-92-8-69 4 107 4-41 2 84 6 124-12z" style="fill:#be8bff"/><path d="m798 509-145-26-124 12-84-6 41-2-107-4-57 4-179 73 69-9 7 7 124-18 105 13 75-7 10 12 74-18 39 8 64-5 7 21 29-20 192 18z" style="fill:#995be6"/></g></defs>';

    string frame =
        '<path fill="#40FF5C" d="M57 58h5v10h5v9h4V49h5v47H66v-9h-4V77h-5v-9h-4v28h-5V49h9v9zm52-4H95v14h9v5h-9v23H85V49h24v5zm0-5h28v5h-9v42h-10V54h-9v-5zm52 52h-24v-5h24v5zm5-47h4v-5h19v5h5v38h-5v4h-19v-4h-5V54zm9 0v37h9V54h-9zm33 42v-4h-5V54h5v-5h24v9h-5v-4h-14v37h9V77h-4v-5h14v24h-5v-5h-4v5h-15zm43 0h-10V49h10v47zm33-42h5v19h-5v4h5v19h-10V77h-9v19h-10V49h24v5zm-14 0v19h9V54h-9zm37 42h-9V49h9v47zM1042 15h23v23h-23zm0 46h23v23h-23zm-23-23h23v23h-23zm0 46h23v23h-23zm0 46h23v23h-23zm23-23h23v23h-23zM801 1016h5v-10h5v-9h-15v-5h24v15h-5v9h-4v10h-5v9h14v5h-24v-15h5v-9zm33-9h5v-15h10v14h4v15h5v19h-10v-14h-14v14h-5v-19h5v-15zm5 0v14h5v-14h-5zm52-10h5v14h-5v5h5v19h-5v5h-24v-48h24v5zm-14 0v14h9v-14h-9zm0 19v19h9v-19h-9zm28-24h10v43h9v-43h9v43h-4v5h-19v-5h-5v-43zm33 0h29v5h-10v43h-9v-43h-10v-5zm33 5h5v-5h19v5h5v38h-5v5h-19v-5h-5v-38zm10 0v38h9v-38h-9zm38 5h4v9h5v10h4v-29h5v48h-9v-10h-5v-9h-5v-10h-4v29h-5v-48h9l1 10zM770 1013l-10-5-10-6-10-6v42l10-6 10-6 10-5z"/><pattern id="c" width="72" height="72" y="1080" patternUnits="userSpaceOnUse" viewBox="72 -72 72 72"><path stroke="#40FF5C" stroke-width="6" d="M144-66h73m-73 24h73m-73 24h73m-73-36h73m-73 24h73M144-6h73M72-66h73M72-42h73M72-18h73M72-54h73M72-30h73M72-6h73M0-66h73M0-42h73M0-18h73M0-54h73M0-30h73M0-6h73"/></pattern><pattern xlink:href="#c" id="d" patternTransform="matrix(1 1 1 -1 -2940 -12099)"/><path fill="url(#d)" d="M29 896h67v140H29z"/><path fill="url(#d)" d="M29 740h67v140H29z"/><path fill="none" stroke="#40FF5C" stroke-miterlimit="10" stroke-width="3.5" d="M28 1054h1024v-24 M28 28v88h300l33-30V28z M490 540h100m-50 50V490 M40 540h100m800 0h100M540 1040V940m0-800V40"/>';

    function getImage(uint256 num) public view returns (string memory) {
        string memory image = "";

        image = string.concat(svgHeader, zabuton);

        for (uint256 idx = 0; idx < num; idx++) {
            image = string.concat(image, '<use xlink:href="#a" x="0" y="');
            int256 yPos = 420 - ((int256)(idx) * 95);
            if (yPos < 0) {
                image = string.concat(image, "-", Strings.toString(uint256(yPos * -1)));
            } else {
                image = string.concat(image, Strings.toString((uint256)(yPos)));
            }
            image = string.concat(image, '"/>');
        }
        image = string.concat(image, frame, "</svg>");
        return image;
    }

    function getSvgHeader() public view onlyOwner returns (string memory) {
        return svgHeader;
    }

    function setSvgHeader(string memory _svgHeader) public onlyOwner {
        svgHeader = _svgHeader;
    }

    function getZabuton() public view onlyOwner returns (string memory) {
        return zabuton;
    }

    function setZabuton(string memory _zabuton) public onlyOwner {
        zabuton = _zabuton;
    }

    function getFrame() public view onlyOwner returns (string memory) {
        return frame;
    }

    function setFrame(string memory _frame) public onlyOwner {
        frame = _frame;
    }
}
