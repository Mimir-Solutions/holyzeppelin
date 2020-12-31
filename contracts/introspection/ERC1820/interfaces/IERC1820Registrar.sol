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
    /**
     * @dev Returns the address for the external registry this 
     */
    function getRegistries() external view returns ( address[] memory );

    function registerWithRegistry( address newRegistry_ ) external returns ( bool );
}
