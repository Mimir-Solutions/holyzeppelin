// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.0;

import "hardhat/console.sol";

import "./interfaces/IERC165.sol";

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
 // TODO to define and provide function IDs based in call / delegateCall signatures.
/*
 *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
 *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
 *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
 *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
 *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
 *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
 *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
 *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
 *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
 *
 *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
 *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
 */
abstract contract IERC165Enhanced is IERC165 {

    function supportedFunctionSelectors() public returns (bytes4[]);
    
}