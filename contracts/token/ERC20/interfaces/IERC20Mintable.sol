// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "hardhat/console.sol";

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
interface ERC20Mintable {

    /**
     * @dev Creates `amount` tokens and transfers to the owner.
     *
     * See {ERC20-_mint}.
     */
    function mint(uint256 amount_) external;
}