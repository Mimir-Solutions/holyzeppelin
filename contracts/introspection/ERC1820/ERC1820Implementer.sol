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
  bytes32 constant public ERC1820_ACCEPT_MAGIC = keccak256( "ERC1820_ACCEPT_MAGIC" );

  bytes32 constant public ERC1820_IMPLEMENTER_INTERFACE_ID = keccak256( "ERC1820Implementer" );

  mapping( bytes32 => mapping( address => bool ) ) private _supportedInterfaces;

  constructor() {
    console.log( "Contract::holyzeppelin::ERC1820Implementer::constructor:1 Instantiating ERC1820Implementer." );

    // TODO switch to using a proper bytes32 to string conversion.
    console.log( "Contract::holyzeppelin::ERC1820Implementer::constructor:2 ERC1820_IMPLEMENTER_INTERFACE_ID interface ID: %s", address( uint256( ERC1820_IMPLEMENTER_INTERFACE_ID ) ) );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    // TODO switch to using a proper bytes32 to string conversion.
    console.log("Contract::holyzeppelin::ERC1820Implementer::constructor:3 Registering ERC1820Implementer of %s for %s.", address( uint256( ERC1820_IMPLEMENTER_INTERFACE_ID ) ), address(this));
    _registerInterfaceForAddress( ERC1820_IMPLEMENTER_INTERFACE_ID, address( this ) );
    console.log( "Contract::holyzeppelin::ERC1820Implementer::constructor:4 Registered ERC1820Implementer." );

    console.log( "Contract::holyzeppelin::ERC1820Implementer::constructor:5 Instantiated ERC1820_IMPLEMENTER_INTERFACE_ID." );
  }

  /**
    * See {IERC1820Implementer-canImplementInterfaceForAddress}.
    */
  function canImplementInterfaceForAddress( bytes32 interfaceHashQuery_, address account ) public view override returns ( bytes32 ) {
    console.log( "Contract::holyzeppelin::ERC1820Implementer::canImplementInterfaceForAddress:1 Checking that this contract impelments %s.", address( uint256( interfaceHashQuery_ ) ) );
    bytes32 implementsInterface_ = _supportedInterfaces[interfaceHashQuery_][account] ? ERC1820_ACCEPT_MAGIC : bytes32(0x00);
    console.log( "Contract::holyzeppelin::ERC1820Implementer::canImplementInterfaceForAddress:2 Returning %s that this contract impelments %s.", address( uint256( implementsInterface_ ) ), address( uint256( interfaceHashQuery_ ) ) );
    return implementsInterface_;
  }

  /**
   * @dev Declares the contract as willing to be an implementer of
   * `interfaceHash` for `account`. Intended to be called by child contracts to register their interfaces.
   *
   * See {IERC1820Registry-setInterfaceImplementer} and
   * {IERC1820Registry-interfaceHash}.
   */
  function _registerInterfaceForAddress( bytes32 interfaceHash_, address account_) internal virtual {
    console.log( "Contract::holyzeppelin::ERC1820Implementer::_registerInterfaceForAddress:1 Self registering that this contract implements interface %s for address %s.", address( uint256( interfaceHash_ ) ), account_ );
    _supportedInterfaces[interfaceHash_][account_] = true;
    console.log( "Contract::holyzeppelin::ERC1820Implementer::_registerInterfaceForAddress:1 Self registering that this contract implements interface %s for address %s.", address( uint256( interfaceHash_ ) ), account_ );
  }

  // TODO write NatSpec comment
  function _encodeFunctionSignature( string  memory functionSignatureToEncode_ ) internal virtual returns ( bytes4 ) {
    console.log( "Contract::holyzeppelin::Returning function selector of %s for function signature of %s.", functionSignatureToEncode_, string( abi.encodePacked( functionSignatureToEncode_ ) ) );
    return bytes4( keccak256( abi.encodePacked( functionSignatureToEncode_ ) ) );
  }
}
