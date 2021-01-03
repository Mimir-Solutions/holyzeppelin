// // SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "../../math/SafeMath.sol";

// /**
//  * @dev String operations.
//  */
library Boolean {

    using SafeMath for uint256;

    function boolToString(bool self_) internal pure returns (string memory _boolAsString) {
      // _boolAsString = self_ ? "1" : "0";
      return self_ ? "1" : "0";
    }
}
