// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

import "./ERC1820Implementer.sol";
import "./interfaces/IERC1820Registrar.sol";
import "./interfaces/IERC1820Registry.sol";
import "../../datatypes/collections/EnumerableSet.sol";



/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC1820Registrar is IERC1820Registrar, ERC1820Implementer {

  using EnumerableSet for EnumerableSet.AddressSet;

  // address constant public _UNIVERSAL_ERC1820_REGISTRY = 0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24;
  bytes32 constant public ERC1820_REGISTRAR_ERC1820_INTERFACE_ID = keccak256("ERC1820Registar");

  address private _registryManager;
  EnumerableSet.AddressSet private _registries;

  // If you wish this address to be it's own manager, simple pass address(0) for registryManager_
  constructor( address[] storage registriesToRegisterWith_, address registryManager_ ) {
    console.log( "Instantiating ERC1820Registar." );

    // TODO switch to using a proper bytes32 to string conversion.
    console.log( "ERC1820_IMPLEMENTER_INTERFACE_ID interface ID: %s", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ) );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    // TODO switch to using a proper bytes32 to string conversion.
    console.log("Registering ERC1820Registar of %s for %s.", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ), address(this));
    _registerInterfaceForAddress( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID, address( this ) );
    console.log( "Registered ERC1820Registar." );

    console.log( "Adding initial registries." );
    // registriesToRegisterWith_.push( _UNIVERSAL_ERC1820_REGISTRY );
    for( uint8 iteration_ = 0; registriesToRegisterWith_.length >= iteration_; iteration_++ ){
      console.log( "Adding registry %s.", registriesToRegisterWith_[iteration_] );
      _registries.add( registriesToRegisterWith_[iteration_] );
      console.log( "Adding registry %s.", _registries.at( iteration_ ) );
    }
    console.log( "Added registries." );

    console.log( "Saving registry manager." );
    _registryManager = registryManager_;
    console.log( "Saved registry manager." );

    console.log( "Registering with registries and setting manager." );
    for( uint8 iteration_ = 0; _registries.length() >= iteration_; iteration_++ ){
      console.log( "Registering iterface %s with registry %s.", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ), _registries.at( iteration_ ) );
      IERC1820Registry( _registries.at( iteration_ ) ).setInterfaceImplementer( address( this ), ERC1820_REGISTRAR_ERC1820_INTERFACE_ID, address( this ) );
      console.log( "Registered iterface %s with registry %s.", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ), _registries.at( iteration_ ) );
      console.log( "Registering manager %s with registry %s.", _registryManager, _registries.at( iteration_ ) );
      IERC1820Registry( _registries.at( iteration_ ) ).setManager( address(this), _registryManager );
      console.log( "Registered manager %s with registry %s.", _registryManager, _registries.at( iteration_ ) );
    }
    console.log( "Registered with registries and set manager." );

    console.log( "Instantiated ERC1820Registar." );
  }

  function registerWithRegistry( address newRegistry_ ) external virtual override returns ( bool ) {
    return _registerWithRegistry( newRegistry_ );
  }

  function _registerWithRegistry( address newRegistry_ ) internal returns ( bool ) {
    require( !_registries.contains( newRegistry_ ) );
    _registries.add( newRegistry_ );
    IERC1820Registry( newRegistry_ ).setInterfaceImplementer( address( this ), ERC1820_REGISTRAR_ERC1820_INTERFACE_ID, address( this ) );
    IERC1820Registry( newRegistry_ ).setManager( address(this), _registryManager );
    return ( address( this ) == IERC1820Registry( newRegistry_ ).getInterfaceImplementer( address( this ), ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) );
  }

  function getRegistries() external view virtual override returns ( address[] memory ) {
    return _getRegistries();
  }

  function _getRegistries() internal view returns ( address[] memory ) {
    return _registries.getValues();
  }
}
