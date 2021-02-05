// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

interface ICHI {
    function mint(uint256 value) external;
    function transfer(address, uint256) external returns(bool);
    function balanceOf(address) external view returns(uint256);
}