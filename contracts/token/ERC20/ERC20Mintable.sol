// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "../../security/access/Ownable.sol";
import "../../security/Context.sol";
import "./ERC20.sol";
import "../../math/SafeMath.sol";

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20Mintable is ERC20, Ownable {

    using SafeMath for uint256;

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function mint(uint256 amount_) public virtual onlyOwner() {
        _mint(owner(), amount_);
    }
}