// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./ERC1820ImplementerERC165Compliant.sol";

/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC165ImplementerERC1820Compliant is ERC1820ImplementerERC165Compliant {

  bytes32 constant public ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID = keccak256("ERC165");

  constructor () {
    console.log( "Instantiating ERC165ERC1820CompliantImplementer." );

    // TODO switch to using a proper bytes32 to string conversion.
    console.log( "ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID interface ID: %s", address( uint256( ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID ) ) );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here

    // TODO switch to using a proper bytes32 to string conversion.
    console.log("Registering ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID of %s for %s with self.", address( uint256( ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID ) ), address(this));
    _registerInterfaceForAddress( ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID, address( this ) );
    console.log( "Registered ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID with self." );

    console.log("Registering ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID of %s for %s with self.", address( uint256( bytes32( ERC165_INTERFACE_ID ) ) ), address(this));
    _registerInterfaceForAddress( ERC165_INTERFACE_ID, address( this ) );
    console.log( "Registered ERC1820ImplementerERC165Compliant with self." );

    console.log( "Instantiated ERC165ERC1820CompliantImplementer." );
  }
}