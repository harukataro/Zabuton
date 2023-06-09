// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IZabutonImage {
    function getImage(uint256 num) external view returns (string memory);
}
