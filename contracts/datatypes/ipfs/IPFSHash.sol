// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;
pragma abicoder v2;

import "hardhat/console.sol";

/*
 * Implemented from https://ethereum.stackexchange.com/questions/17094/how-to-store-ipfs-hash-using-bytes32 from user MidnightLightning
 */
library IPFSHash {

  struct MultiHash {
    uint8 hashFunction;
    uint8 size;
    bytes32 contentGash;
  }

  /*
   * Adds a new hash when used to set a variable.
   */
  function add(MultiHash storage nultiHash_, uint8 hashFunction_, uint8 size_, bytes32 contentGash_ ) internal returns ( bool succeeded_ ) {
    nultiHash_.hashFunction = hashFunction_;
    nultiHash_.size = size_;
    nultiHash_.contentGash = contentGash_;
    return true;
  }

  function get(MultiHash storage nultiHash_ ) internal returns ( uint8 hashFunction_, uint8 size_, bytes32 contentGash_ ) {
    return ( nultiHash_.hashFunction, nultiHash_.size = size_, nultiHash_.contentGash );
  }
}
