// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
import "hardhat/console.sol";

import "./ERC1820Implementer.sol";

/**
 * @dev As per the ERC1820 OepnZeppelin Implementation for setManager:
 *  Sets `newManager` as the manager for `account`. A manager of an
 *  account is able to set interface implementers for it.
 *
 *  By default, each account is its own manager. Passing a value of `0x0` in
 *  `newManager` will reset the manager to this initial state.
 *
 *  Emits a {ManagerChanged} event.
 *
 *  Requirements:
 *
 *  - the caller must be the current manager for `account`.
 *
 * This contract faciliates other contract registering themselves and
 * their interfaces with a IERC1820Registry implementation.
 */
abstract contract ERC1820Registar is ERC1820Implementer {

  IERC1820Registry public registry;

  function _setRegistry( address registry_ ) internal {
    registry = IERC1820Registry(registry_);
  }

  /**
   * Is intended to be called by inheriting contract so implementation can decide the
   * manager address. It is recommend that contract set themselves as their own manager and then
   * register their interfaces in their constructor.
   * 
   * If a contract wishes to expose this for external management it is up to them to implement
   * the external manager.
   */
  function _registerManager( address newManager_ ) private {
    registry.setManager( address(this), newManager_ );
  }

  function _registerERC1820CompliantInterfaceID( string erc1820CompliantInterfaceID_, address manager_, address interfaceCallReceiver_, address implementer_ ) private {
    registry.setInterfaceImplementer(
      interfaceCallReceiver_,
      registry.interfaceHash( erc1820CompliantInterfaceID_ ),
      implementer_
    );
  }

}