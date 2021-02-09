// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./interfaces/IERC165.sol";
import "../../datatypes/primitives/Bytes4.sol";

/**
 * @dev Implementation of the {IERC165} interface.
 *  This is an example of how to calculate the ERC165 interfce ID based on ERC777
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
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
abstract contract ERC165 is IERC165 {

  using Bytes4 for bytes4;
    /**
     * @dev ERC165_INTERFACE_ID Calculated using the forumula bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 public constant ERC165_INTERFACE_ID = type(IERC165).interfaceId;
    //  = bytes4( keccak256( "supportsInterface(bytes4)" ) );

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () {
      console.log("Contract::holyzeppelin::ERC165::constructor:01 Instantiating ERC165.");

      console.log("Contract::holyzeppelin::ERC165::constructor:02 Registering ERC165_INTERFACE_ID.");
      _registerInterface(ERC165_INTERFACE_ID);
      console.log("Contract::holyzeppelin::ERC165::constructor:03 Registered ERC165_INTERFACE_ID.");

      console.log("Contract::holyzeppelin::ERC165::constructor:04 Instantiated ERC165.");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface( bytes4 interfaceId_ ) external view override returns (bool) {
      // console.log( "Contract::holyzeppelin::ERC165::supportsInterface:01 Does this contract at %s implement interface %s? %s", address( this ), interfaceId_.toString, _supportedInterfaces[interfaceId_] );
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
    function _registerInterface( bytes4 interfaceId_ ) internal virtual {
      require(interfaceId_ != 0xffffffff, "ERC165: invalid interface id");
      _supportedInterfaces[interfaceId_] = true;
    }
}
