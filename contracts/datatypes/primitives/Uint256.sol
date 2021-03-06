// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

// import "hardhat/console.sol";

// /**
//  * @dev Wrappers over Solidity's arithmetic operations with added overflow
//  * checks.
//  *
//  * Arithmetic operations in Solidity wrap on overflow. This can easily result
//  * in bugs, because programmers usually assume that an overflow raises an
//  * error, which is the standard behavior in high level programming languages.
//  * `SafeMath` restores this intuition by reverting the transaction when an
//  * operation overflows.
//  *
//  * Using this library instead of the unchecked operations eliminates an entire
//  * class of bugs, so it's recommended to use it always.
//  */
//  // TODO needs versions for uint4, uint8, uint16, uint32, uint64, uint128, int4, int8, int16, int32, int64, int128, int256 or confrimation casting is safe.
library Uint256 {
    // /**
    //  * @dev Returns the addition of two unsigned integers, reverting on
    //  * overflow.
    //  *
    //  * Counterpart to Solidity's `+` operator.
    //  *
    //  * Requirements:
    //  *
    //  * - Addition cannot overflow.
    //  */
    // function add(uint256 a, uint256 b) internal pure returns (uint256) {
    //     uint256 c = a + b;
    //     require(c >= a, "SafeMath: addition overflow");

    //     return c;
    // }

    // /**
    //  * @dev Returns the subtraction of two unsigned integers, reverting on
    //  * overflow (when the result is negative).
    //  *
    //  * Counterpart to Solidity's `-` operator.
    //  *
    //  * Requirements:
    //  *
    //  * - Subtraction cannot overflow.
    //  */
    // function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return sub(a, b, "SafeMath: subtraction overflow");
    // }

    // /**
    //  * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
    //  * overflow (when the result is negative).
    //  *
    //  * Counterpart to Solidity's `-` operator.
    //  *
    //  * Requirements:
    //  *
    //  * - Subtraction cannot overflow.
    //  */
    // function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    //     require(b <= a, errorMessage);
    //     uint256 c = a - b;

    //     return c;
    // }

    // /**
    //  * @dev Returns the multiplication of two unsigned integers, reverting on
    //  * overflow.
    //  *
    //  * Counterpart to Solidity's `*` operator.
    //  *
    //  * Requirements:
    //  *
    //  * - Multiplication cannot overflow.
    //  */
    // function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    //     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    //     // benefit is lost if 'b' is also tested.
    //     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    //     if (a == 0) {
    //         return 0;
    //     }

    //     uint256 c = a * b;
    //     require(c / a == b, "SafeMath: multiplication overflow");

    //     return c;
    // }

    // /**
    //  * @dev Returns the integer division of two unsigned integers. Reverts on
    //  * division by zero. The result is rounded towards zero.
    //  *
    //  * Counterpart to Solidity's `/` operator. Note: this function uses a
    //  * `revert` opcode (which leaves remaining gas untouched) while Solidity
    //  * uses an invalid opcode to revert (consuming all remaining gas).
    //  *
    //  * Requirements:
    //  *
    //  * - The divisor cannot be zero.
    //  */
    // function div(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return div(a, b, "SafeMath: division by zero");
    // }

    // /**
    //  * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
    //  * division by zero. The result is rounded towards zero.
    //  *
    //  * Counterpart to Solidity's `/` operator. Note: this function uses a
    //  * `revert` opcode (which leaves remaining gas untouched) while Solidity
    //  * uses an invalid opcode to revert (consuming all remaining gas).
    //  *
    //  * Requirements:
    //  *
    //  * - The divisor cannot be zero.
    //  */
    // function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    //     require(b > 0, errorMessage);
    //     uint256 c = a / b;
    //     // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    //     return c;
    // }

    // /**
    //  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    //  * Reverts when dividing by zero.
    //  *
    //  * Counterpart to Solidity's `%` operator. This function uses a `revert`
    //  * opcode (which leaves remaining gas untouched) while Solidity uses an
    //  * invalid opcode to revert (consuming all remaining gas).
    //  *
    //  * Requirements:
    //  *
    //  * - The divisor cannot be zero.
    //  */
    // function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return mod(a, b, "SafeMath: modulo by zero");
    // }

    // /**
    //  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    //  * Reverts with custom message when dividing by zero.
    //  *
    //  * Counterpart to Solidity's `%` operator. This function uses a `revert`
    //  * opcode (which leaves remaining gas untouched) while Solidity uses an
    //  * invalid opcode to revert (consuming all remaining gas).
    //  *
    //  * Requirements:
    //  *
    //  * - The divisor cannot be zero.
    //  */
    // function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    //     require(b != 0, errorMessage);
    //     return a % b;
    // }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    // function sqrrt(uint256 a) internal pure returns (uint c) {
    //     if (a > 3) {
    //         c = a;
    //         uint b = add( div( a, 2), 1 );
    //         while (b < c) {
    //             c = b;
    //             b = div( add( div( a, b ), b), 2 );
    //         }
    //     } else if (a != 0) {
    //         c = 1;
    //     }
    // }

  function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = byte(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }

    // function uintToBytes(uint _offst, uint _input, bytes memory _output) internal pure {

    //     assembly {
    //         mstore(add(_output, _offst), _input)
    //     }
    // }   
}
