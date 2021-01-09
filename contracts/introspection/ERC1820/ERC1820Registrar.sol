// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./ERC165ImplementerERC1820Compliant.sol";
import "./interfaces/IERC1820Registrar.sol";
import "./interfaces/IERC1820Registry.sol";
import "../../datatypes/collections/EnumerableMap.sol";
import "../../datatypes/collections/EnumerableSet.sol";
import "../../security/Context.sol";

/**
 * @dev Implementation of the {IERC1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IERC1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
abstract contract ERC1820Registrar is IERC1820Registrar, ERC165ImplementerERC1820Compliant {

  using EnumerableSet for EnumerableSet.AddressSet;
  using EnumerableSet for EnumerableSet.Bytes4Set;
  using EnumerableSet for EnumerableSet.Bytes32Set;

  // 0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
  // Made mutable for testing purposes.
  // address public _UNIVERSAL_ERC1820_REGISTRY;
  
  bytes4 constant public ERC1820_REGISTRAR_ERC165_INTERFACE_ID = 
    bytes4( keccak256( "setRegistryManager(address)" ) )
    ^ bytes4( keccak256( "registerWithNewRegistry(address)" ) )
    ^ bytes4( keccak256( "getRegistries()" ) );

  bytes32 constant public ERC1820_REGISTRAR_ERC1820_INTERFACE_ID = keccak256("ERC1820Registar");

  EnumerableSet.Bytes4Set private _erc165ImplementedInterfaces;
  EnumerableSet.Bytes32Set  private _erc1820ImplementedInterfaces;
  
  address public registryManager;
  EnumerableSet.AddressSet private _registries;

  modifier onlyManager() {
    console.log( "ERC1820Registrar::onlyManager:1 Confimging msg.sender is registry manager." );
    require( Context._msgSender() == registryManager, "msg.sender is not the registry amanger." );
    console.log( "ERC1820Registrar::onlyManager:2 Confimed msg.sender is registry manager." );
    _;
  }

  // If you wish this address to be it's own manager, simple pass address(0) for registryManager_
  constructor( address[] memory registriesToRegisterWith_, address registryManager_ ) {
    console.log( "ERC1820Registrar::constructor:1 Instantiating ERC1820Registar." );

    // TODO switch to using a proper bytes32 to string conversion.
    console.log( "ERC1820Registrar::constructor:2 ERC1820_REGISTRAR_ERC1820_INTERFACE_ID interface ID: %s", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ) );
    
    _addERC165InterfaceIDToSelf( ERC165_INTERFACE_ID );
    _addERC165InterfaceIDToSelf( ERC1820_IMPLEMENTER_ERC165_INTERFACE_ID );
    _addERC165InterfaceIDToSelf( ERC1820_REGISTRAR_ERC165_INTERFACE_ID );

    _addERC1820InterfaceIDToSelf( ERC165_IMPLEMENTER_ERC1820_COMPLIANT_INTERFACE_ID );
    _addERC1820InterfaceIDToSelf( ERC1820_IMPLEMENTER_INTERFACE_ID );
    _addERC1820InterfaceIDToSelf( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID );

    console.log( "ERC1820Registrar::constructor:7 Saving registry manager of %s.",  registryManager_);
    _setRegistryManager( registryManager_ );
    console.log( "ERC1820Registrar::constructor:8 Saved registry manager of %s.", registryManager_ );

    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC1820Implementer itself here
    // TODO switch to using a proper bytes32 to string conversion.
    // console.log( "ERC1820Registrar::constructor:5 Registering ERC1820_REGISTRAR_ERC1820_INTERFACE_ID of %s for %s with self.", address( uint256( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID ) ), address(this));
    // _registerInterfaceForAddress( ERC1820_REGISTRAR_ERC1820_INTERFACE_ID, address( this ) );
    // console.log( "ERC1820Registrar::constructor:6 Registered ERC1820_REGISTRAR_ERC1820_INTERFACE_ID with self." );

    // console.log( "Adding initial registries." );
    // registriesToRegisterWith_.push( _UNIVERSAL_ERC1820_REGISTRY );
    console.log( "ERC1820Registrar::constructor:9 Adding Registries from constructor argument." );
    for( uint8 iteration_ = 0; registriesToRegisterWith_.length >= iteration_; iteration_++ ){
      console.log( "ERC1820Registrar::constructor:10 Adding registry %s.", registriesToRegisterWith_[iteration_] );
      _addRegistry( registriesToRegisterWith_[iteration_] );
      console.log( "ERC1820Registrar::constructor:11 Added registry %s.", _registries.at( iteration_ ) );
    }
    console.log( "ERC1820Registrar::constructor:12 Added registries from constructor argument." );

    console.log( "ERC1820Registrar::constructor:37 Instantiated ERC1820Registar." ); 
  }

  /*
   * TODO update to NatSpec comment
   * intended to be used by child contracts to add their interfaces to an array for easy registration with new 
   */
  function _addERC165InterfaceIDToSelf( bytes4 erc165InterfaceIDToAdd_ ) internal virtual returns ( bool ) {
    console.log( "ERC1820Registrar::_addERC165InterfaceID:1 Adding ERC165 interface ID of %s to set of implemented interfaces." );
    console.log( "ERC1820Registrar::_addERC165InterfaceID:2 Confirming ERC165 interface not present." );
    require( !_erc165ImplementedInterfaces.contains( erc165InterfaceIDToAdd_ ), "ERC165 interface ID already present." );
    console.log( "ERC1820Registrar::_addERC165InterfaceID:3 Adding ERC165 interface ID." );
    _erc165ImplementedInterfaces.add( erc165InterfaceIDToAdd_ );
    console.log( "ERC1820Registrar::_addERC165InterfaceID:4 Added ERC165 interface ID." );
    console.log( "ERC1820Registrar::_addERC165InterfaceID:5 Returning true to indicate success." );
    return true;
  }

  /*
   * TODO update to NatSpec comment
   * intended to be used by child contracts to add their interfaces to an array for easy registration with new 
   */
  function _addERC1820InterfaceIDToSelf( bytes32 erc1820InterfaceIDToAdd_ ) internal virtual returns ( bool ) {
    console.log( "ERC1820Registrar::_addERC1820InterfaceID:1 Adding ERC1820 interface ID of %s to set of implemented interfaces." );
    console.log( "ERC1820Registrar::_addERC1820InterfaceID:2 Confirming ERC1820 interface not present." );
    require( !_erc1820ImplementedInterfaces.contains( erc1820InterfaceIDToAdd_ ), "ERC165 interface ID already present." );
    console.log( "ERC1820Registrar::_addERC1820InterfaceID:3 Adding ERC1820 interface ID." );
    _erc1820ImplementedInterfaces.add( erc1820InterfaceIDToAdd_ );
    console.log( "ERC1820Registrar::_addERC1820InterfaceID:4 Added ERC1820 interface ID." );
    console.log( "ERC1820Registrar::_addERC1820InterfaceID:5 Returning true to indicate success." );

    console.log( "ERC1820Registrar::_addERC165InterfaceID:5 Returning true to indicate success." );
    return true;
  }

  /*
   * TODO update to NatSpec comment
   * intended to be used by child contracts to register their interfaces with themselves as ERC1820Implementers
   */
  function _registerInterfacesWithSelf() internal virtual returns ( bool ) {
    console.log( "ERC1820Registrar::_registerInterfacesWithSelf:1 Adding ERC165 interface IDs from constructor arguments." );
    for( uint8 iteration_; _erc165ImplementedInterfaces.length() > iteration_; iteration_++ ) {
      console.log( "ERC1820Registrar::_registerInterfacesWithSelf:2 Adding ERC165_INTERFACE_ID interface ID of %s to interface array of ERC165 interfaces.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ) );
      _registerInterfaceForAddress( _erc165ImplementedInterfaces.at(iteration_), address(this) );
      console.log( "ERC1820Registrar::_registerInterfacesWithSelf:2 Added ERC165_INTERFACE_ID interface ID of %s to interface array of ERC165 interfaces.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ) );
    }
    console.log( "ERC1820Registrar::_registerInterfacesWithSelf:4 Added ERC165 interface IDs from constructor arguments." );

    console.log( "ERC1820Registrar::_registerInterfacesWithSelf:5 Adding ERC1820 interface IDs from constructor arguments." );
    for( uint8 iteration_; _erc1820ImplementedInterfaces.length() > iteration_; iteration_++ ) {
      console.log( "ERC1820Registrar::_registerInterfacesWithSelf:6 Adding ERC165_INTERFACE_ID interface ID of %s to interface array of ERC165 interfaces.", address( uint256( _erc1820ImplementedInterfaces.at( iteration_ ) ) ) );
      _registerInterfaceForAddress( _erc1820ImplementedInterfaces.at(iteration_), address(this) );
      console.log( "ERC1820Registrar::_registerInterfacesWithSelf:7 Added ERC165_INTERFACE_ID interface ID of %s to interface array of ERC165 interfaces.", address( uint256( _erc1820ImplementedInterfaces.at( iteration_ ) ) ) );
    }
    console.log( "ERC1820Registrar::_registerInterfacesWithSelf:8 Added ERC1820 interface IDs from constructor arguments." );

    console.log( "ERC1820Registrar::_addERC165InterfaceID:5 Returning true to indicate success." );
    return true;
  }

  /*
   * TODO update to Natspec comment
   * Not generally intended for most use cases.
   * Intended usage is for registry manager to add new registries to registrar, then use registerWithRegistries() or registerWithRegistry().
   * Provided to facilitate other management models.
   */
  function _setRegistryManager( address newRegistryManager_ ) internal virtual returns ( bool ) {
    console.log( "ERC1820Registrar::_setRegistryManager:1 Setting registry manager." );
    console.log( "ERC1820Registrar::_setRegistryManager:2 Checking if newRegistryManager_ is address 0." );
    if( newRegistryManager_ == address(0) ){
      console.log( "ERC1820Registrar::_setRegistryManager:3 newRegistryManager_ is %s, setting to address(this) of %s.", newRegistryManager_, address(this) );
      registryManager = address(this);
      console.log( "ERC1820Registrar::_setRegistryManager:4 newRegistryManager_ is %s, set to address(this) of %s.", newRegistryManager_, address(this) );
    } else {
      console.log( "ERC1820Registrar::_setRegistryManager:5 newRegistryManager_ is %s, setting to address(this) of %s.", newRegistryManager_, address(this) );
      registryManager = newRegistryManager_;
      console.log( "ERC1820Registrar::_setRegistryManager:6 newRegistryManager_ is %s, set to address(this) of %s.", newRegistryManager_, address(this) );
    }
    console.log( "ERC1820Registrar::_setRegistryManager:7 Set registry manager." );
    console.log( "ERC1820Registrar::_setRegistryManager:8 Returning true to indicate success." );
    return true;
  }

  /*
   * TODO update to Natspec comment
   * Exposes _setRegistryManager() internal function.
   * Internal implementation separated from external exposure to minimize gas costs when using internal function.
   */
  function setRegistryManager( address newRegistryManager_ ) external virtual override onlyManager() returns ( bool ) {
    console.log( "ERC1820Registrar::setRegistryManager:1 Setting registry manager from external call." );
    return _setRegistryManager( newRegistryManager_ );
  }

  function _addRegistry( address newRegistry_ ) internal virtual returns ( bool ) {
    console.log( "ERC1820Registrar::_addRegistry:1 Confirming registry was not already added," );
    require( !_registries.contains( newRegistry_ ), "Registry already added." );
    console.log( "Registry is not present." );
    console.log( "Adding registry." );
    _registries.add( newRegistry_ );
    console.log( "Added registry." );
    console.log( "Returning true to indicate success," );
    return true;
  }

  function _updateRegistryERC165Cache( address registry_, bytes4 erc165InterfaceIDToRegister_ ) internal virtual returns ( bool ) {
    console.log( "Registering ERC165 iterface %s with registry %s.", address( uint256( bytes32( erc165InterfaceIDToRegister_ ) ) ), registry_ );
    IERC1820Registry( registry_ ).updateERC165Cache( address( this ), erc165InterfaceIDToRegister_ );
    console.log( "Registered ERC165 iterface %s with registry %s.", address( uint256( bytes32( erc165InterfaceIDToRegister_ ) ) ), registry_ );
    console.log( "Returning true to indicate success." );
    return true;
  }

  function _setRegistryInterfaceImplementer( address registry_, bytes32 erc1820InterfaceID_ ) internal virtual returns ( bool ) {
    console.log( "Registering ERC1820 iterface %s with registry %s.", address( uint256( erc1820InterfaceID_ ) ), registry_);
    IERC1820Registry( registry_ ).setInterfaceImplementer( address( this ), erc1820InterfaceID_, address( this ) );
    console.log( "Registered ERC1820 iterface %s with registry %s.", address( uint256( erc1820InterfaceID_ ) ), registry_ );
    console.log( "Returning true to indicate success." );
    return true;
  }

  function _registerRegistryManager( address registry_, address registryManager_ ) internal virtual returns ( bool ) {
    console.log( "Registering manager %s with registry %s.", registryManager, registry_ );
    IERC1820Registry( registry_ ).setManager( address(this), registryManager_ );
    console.log( "Registered manager %s with registry %s.", registryManager, registry_ );
    console.log( "Returning true to indicate success." );
    return true;
  }

  function _registerWitRegistry( address newRegistry_ ) internal virtual returns ( bool ) {
    console.log( "Registering with new registry." );
    for( uint8 iteration_ = 0; _erc165ImplementedInterfaces.length() >= iteration_; iteration_++ ){
      console.log( "Registering ERC165 iterface %s with registry %s.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ), newRegistry_ );
      IERC1820Registry( newRegistry_ ).updateERC165Cache( address( this ), _erc165ImplementedInterfaces.at( iteration_ ) );
      console.log( "Registered ERC165 iterface %s with registry %s.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ), newRegistry_ );
    }

    for( uint8 iteration_ = 0; _erc1820ImplementedInterfaces.length() >= iteration_; iteration_++ ){
      console.log( "Registering ERC1820 iterface %s with registry %s.", address( uint256( _erc1820ImplementedInterfaces.at( iteration_ ) ) ), newRegistry_ );
      IERC1820Registry( newRegistry_ ).setInterfaceImplementer( address( this ), _erc1820ImplementedInterfaces.at( iteration_ ), address( this ) );
      console.log( "Registered ERC1820 iterface %s with registry %s.", address( uint256( _erc1820ImplementedInterfaces.at( iteration_ ) ) ), newRegistry_);
    }

    _registerRegistryManager( newRegistry_, registryManager );
    console.log( "Registered with new registry." );

    return true;
  }

  function _registerWithRegisties() internal virtual {
    console.log( "ERC1820Registrar::constructor:29 Registering interface IDs." );
    for( uint8 iteration_; _registries.length() > iteration_; iteration_++ ) {
      console.log( "ERC1820Registrar::constructor:30 Registering ERC165 interface ID of %s with registry %s.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ), _registries.at( iteration_ ) );
      _registerWitRegistry( _registries.at( iteration_ ) );
      console.log( "ERC1820Registrar::constructor:31 Registered ERC165 interface ID of %s with registry %s.", address( uint256( bytes32( _erc165ImplementedInterfaces.at( iteration_ ) ) ) ), _registries.at( iteration_ ) );
    }
    console.log( "ERC1820Registrar::constructor:32 Registered interface IDs." );
  }

  function registerWithNewRegistry( address newRegistry_ ) external virtual override onlyManager() returns ( bool ) {
    require( _addRegistry( newRegistry_ ) );
    require( _registerWitRegistry( newRegistry_ ) );
    return _registerRegistryManager( newRegistry_, registryManager );
  }

  function _getRegistries() internal view virtual returns ( address[] memory ) {
    return _registries.getValues();
  }

  function getRegistries() external view virtual override returns ( address[] memory ) {
    return _getRegistries();
  }
}
