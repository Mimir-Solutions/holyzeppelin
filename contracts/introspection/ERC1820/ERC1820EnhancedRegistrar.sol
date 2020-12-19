// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
import "hardhat/console.sol";

import "../../access/Ownable.sol";
import "./ERC1820/ERC1820Implementer.sol";
import "./intefraces/IERC1820Registry.sol";

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
abstract contract ERC1820EnhancedRegistar is ERC1820EnhancedImplementer {

  function _registerERC165CompliantInterfaceID( address implementer_. bytes4 interfaceID_ ) private {
    registry.updateERC165Cache( implementer_, interfaceID_ );
  }
}