// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

interface IOwnable {

  function owner() external view virtual returns (address);

  function renounceOwnership() external virtual;
  
  function transferOwnership( address newOwner_ ) external virtual;
}
