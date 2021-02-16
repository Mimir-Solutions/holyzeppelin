// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "../ERC20.sol";
import "../../../security/access/Ownable.sol";
import "../../../math/SafeMath.sol";

abstract contract ERC20MintableBurnable is ERC20, Ownable {

  using SafeMath for uint256;

  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_
  ) ERC20( name_, symbol_, decimals_ ) {}

  /**
   * @dev Destroys `amount` tokens from the caller.
   *
   * See {ERC20-_burn}.
   */
  function mint(uint256 amount_) public virtual onlyOwner() {
    _mint(owner(), amount_);
  }

  /**
   * @dev Destroys `amount` tokens from the caller.
   *
   * See {ERC20-_burn}.
   */
  function burn(uint256 amount) public virtual {
    _burn(Context._msgSender(), amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, deducting from the caller's
   * allowance.
   *
   * See {ERC20-_burn} and {ERC20-allowance}.
   *
   * Requirements:
   *
   * - the caller must have allowance for ``accounts``'s tokens of at least
   * `amount`.
   */
  function burnFrom( address account_, uint256 amount_ ) public virtual {
    _burnFrom( account_, amount_ );
  }

  function _burnFrom( address account_, uint256 amount_ ) public virtual {
    uint256 decreasedAllowance_ = allowance( account_, Context._msgSender() ).sub( amount_, "ERC20: burn amount exceeds allowance");

    _approve( account_, Context._msgSender(), decreasedAllowance_ );
    _burn( account_, amount_ );
  }
}