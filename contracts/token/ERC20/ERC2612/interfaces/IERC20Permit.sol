// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

interface IERC20Permit {

  // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
  function PERMIT_TYPEHASH() external view returns ( bytes32 );

  function DOMAIN_SEPARATOR() external view returns ( bytes32 );

  /**
   * @dev See {IERC2612Permit-permit}.
   *
   */
  function permit( address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) external;

  /**
   * @dev See {IERC2612Permit-nonces}.
   */
  function nonces(address owner) external view returns (uint256);
}