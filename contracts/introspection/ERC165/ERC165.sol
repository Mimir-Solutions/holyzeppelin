// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

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
abstract contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 public immutable ERC165_INTERFACE_ID
    //  = 0x01ffc9a7
    ;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () {
      console.log("Instantiating ERC165.");
      console.log("Calculating ERC165_INTERFACE_ID.");
      // Derived contracts need only register support for their own interfaces,
      // we register support for ERC165 itself here
      ERC165_INTERFACE_ID = bytes4(keccak256('supportsInterface(bytes4)'));
      console.log("Calculating ERC165_INTERFACE_ID.");
      console.log("IERC165Enhanced interface ID: %s", ERC165_INTERFACE_ID);
      console.log("Registering ERC165_INTERFACE_ID.");
      _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
      console.log("Registered ERC165_INTERFACE_ID.");
      console.log("Instantiated ERC165.");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId_) public view override returns (bool) {
      console.log("Self identifying that %s implements interface %s.", address(this), interfaceId_);
      return _supportedInterfaces[interfaceId_];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId_) internal virtual {
        require(interfaceId_ != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId_] = true;
    }
}
