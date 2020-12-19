// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./IERC1820Implementer.sol";

/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC1820EnhancedImplementer is ERC165Enhanced, ERC1820Implementer {

  constructor () {
    console.log("Instantiating ERC1820Implementer.");

    console.log("Calculating ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
    ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID = bytes4(keccak256('canImplementInterfaceForAddress(bytes32,address)')));
    console.log("Calculated ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
    console.log("ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID interface ID: %s", ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID);
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    console.log("Registering ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
    console.log("IERC1820Implementer interface ID: %s", ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID);
    _registerInterface( ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID );
    console.log("Registered ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");

    console.log("Registering ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID of %s for %s.", ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID, address(this));
    _registerInterfaceForAddress( ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID, address(this) );
    console.log("Registered IERC1820Implementer.");

    console.log("Calculating ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
    ERC165_INTERFACE_ERC1820_ID = keccak256('ERC165');
    console.log("Calculated ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
    console.log("ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID interface ID: %s", ERC165_INTERFACE_ERC1820_ID);

    console.log("Registering ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID of %s for %s.", ERC165_INTERFACE_ERC1820_ID, address(this));
    _registerInterfaceForAddress( ERC165_INTERFACE_ERC1820_ID, address(this) );
    console.log("Registered IERC1820Implementer.");

    console.log("Instantiated ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID.");
  }
}
