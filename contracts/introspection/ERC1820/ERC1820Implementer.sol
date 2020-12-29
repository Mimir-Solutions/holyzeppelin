// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./interfaces/IERC1820Implementer.sol";



/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC1820Implementer is IERC1820Implementer {
  bytes32 constant public ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

  bytes32 constant public ERC1820_IMPLEMENTER_INTERFACE_ID = keccak256("ERC1820Implementer");

  mapping(bytes32 => mapping(address => bool)) private _supportedInterfaces;

  constructor () {
    console.log("Instantiating ERC1820Implementer.");

    // console.log("ERC1820_IMPLEMENTER_INTERFACE_ID interface ID: %s", string(uint256(ERC1820_IMPLEMENTER_INTERFACE_ID)));
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    // console.log("Registering ERC1820Implementer of %s for %s.", string(bytes32(uint256(ERC1820_IMPLEMENTER_INTERFACE_ID))), address(this));
    _registerInterfaceForAddress( ERC1820_IMPLEMENTER_INTERFACE_ID, address(this) );
    console.log("Registered ERC1820Implementer.");

    console.log("Instantiated ERC1820_IMPLEMENTER_INTERFACE_ID.");
  }

  /**
    * See {IERC1820Implementer-canImplementInterfaceForAddress}.
    */
  function canImplementInterfaceForAddress(bytes32 interfaceHashQuery_, address account) public view override returns (bytes32) {
    return _supportedInterfaces[interfaceHashQuery_][account] ? ERC1820_ACCEPT_MAGIC : bytes32(0x00);
  }

  /**
   * @dev Declares the contract as willing to be an implementer of
   * `interfaceHash` for `account`.
   *
   * See {IERC1820Registry-setInterfaceImplementer} and
   * {IERC1820Registry-interfaceHash}.
   */
  function _registerInterfaceForAddress(bytes32 interfaceHash_, address account_) internal virtual {
    //require( ERC165Checker.supportsInterface(account_, interfaceHash_) );
    _supportedInterfaces[interfaceHash_][account_] = true;
  }
}
