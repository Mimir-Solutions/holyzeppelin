// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

/**
 * @dev Interface for an ERC1820 implementer, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820#interface-implementation-erc1820implementerinterface[EIP].
 * Used by contracts that will be registered as implementers in the
 * {IERC1820Registry}.
 */
interface IERC1820Registrar {

  /*
   * TODO update to Natspec comment
   * Exposes _setRegistryManager() internal function.
   * Internal implementation separated from external exposure to minimize gas costs when using internal function.
   */
  function setRegistryManager( address newRegistryManager_ ) external returns ( bool );

  function registerWithNewRegistry( address newRegistry_ ) external returns ( bool );

  function getRegistries() external view returns ( address[] memory );
}
