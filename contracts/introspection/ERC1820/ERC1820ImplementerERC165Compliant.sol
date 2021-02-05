// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./ERC1820Implementer.sol";
import "../ERC165/ERC165.sol";

/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC1820ImplementerERC165Compliant is ERC1820Implementer, ERC165 {

  bytes4 constant public ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID = bytes4( keccak256("canImplementInterfaceForAddress(bytes32,address)") );

  constructor () {
    console.log( "Instantiating ERC1820ImplementerERC165Compliant." );

    // TODO switch to using a proper bytes32 to string conversion.
    console.log( "ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID interface ID: %s", address( uint256( bytes32( ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID ) ) ) );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    
    console.log("Registering ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID.");
    _registerInterface( ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID );
    console.log("Registered ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID.");

    // TODO switch to using a proper bytes32 to string conversion.
    console.log("Registering ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID of %s for %s with self.", address( uint256( bytes32( ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID )  ) ), address( this ) );
    _registerInterfaceForAddress( ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID, address( this ) );
    console.log( "Registered ERC1820ImplementerERC165Compliant with self." );

    console.log("Registering ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID of %s for %s with self.", address( uint256( bytes32( ERC165_INTERFACE_ID ) ) ), address(this));
    _registerInterfaceForAddress( ERC165_INTERFACE_ID, address( this ) );
    console.log( "Registered ERC1820ImplementerERC165Compliant with self." );

    console.log( "Instantiated ERC1820ImplementerERC165Compliant." );
  }
}
