// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

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
 *     bytes4(keccak256("supportsInterface(bytes4)")) == 0x01ffc9a7
 */
abstract contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 public constant ERC165_INTERFACE_ID = bytes4( keccak256( "supportsInterface(bytes4)" ) );

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() {
      console.log("ERC165::constructor:1 Instantiating ERC165.");
      
      // Derived contracts need only register support for their own interfaces,
      // Registering ERC165 interface to facilitate validation from other contracts.
      // not having it registered would require special consideration of the ERC165 interface.
      console.log("ERC165::constructor:2 ERC165 interface ID: %s", address( uint256( bytes32( ERC165_INTERFACE_ID ) ) ) );
      console.log("ERC165::constructor:3 Registering ERC165_INTERFACE_ID with self.");
      _registerInterface( ERC165_INTERFACE_ID );
      console.log("ERC165::constructor:4 Registered ERC165_INTERFACE_ID with self.");

      console.log("ERC165::constructor:5 Instantiated ERC165.");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface( bytes4 interfaceId_ ) public view override returns (bool) {
      console.log("ERC165::supportsInterface:1 Self identifying that %s implements interface %s.", address(this), address( uint256( bytes32( interfaceId_ ) ) ) );
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
      console.log( "ERC165::_registerInterface:1 Confirming interface %s is valid ERC165 interface ID.", address ( uint256( bytes32( interfaceId_ ) ) ) );
      require(interfaceId_ != 0xffffffff, "ERC165: invalid interface id");
      console.log( "ERC165::_registerInterface:2 Confirmed interface %s is valid ERC165 interface ID.", address ( uint256( bytes32( interfaceId_ ) ) ) );
      console.log( "ERC165::_registerInterface:3 Setting implementation self report of interface %s.", address( uint256( bytes32( interfaceId_ ) ) ) );
      _supportedInterfaces[interfaceId_] = true;
      console.log( "ERC165::_registerInterface:4 Set implementation self report of interface %s.", address( uint256( bytes32( interfaceId_ ) ) ) );
    }
}
