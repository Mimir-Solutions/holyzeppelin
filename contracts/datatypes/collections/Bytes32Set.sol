// // // SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "./EnumerableSet.sol";

library Bytes32Set {

  // using EnumerableSet for EnumerableSet.Set;

  // struct Bytes32Set {
  //   EnumerableSet.Set _inner;
  // }

  // /**
  //    * @dev Add a value to a set. O(1).
  //    *
  //    * Returns true if the value was added to the set, that is if it was not
  //    * already present.
  //    */
  //   function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
  //       return EnumerableSet.Set._add(set._inner, value);
  //   }

  //   /**
  //    * @dev Removes a value from a set. O(1).
  //    *
  //    * Returns true if the value was removed from the set, that is if it was
  //    * present.
  //    */
  //   function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
  //       return EnumerableSet.Set._remove(set._inner, value);
  //   }

  //   /**
  //    * @dev Returns true if the value is in the set. O(1).
  //    */
  //   function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
  //       return EnumerableSet.Set._contains(set._inner, value);
  //   }

  //   /**
  //    * @dev Returns the number of values on the set. O(1).
  //    */
  //   function length(Bytes32Set storage set) internal view returns (uint256) {
  //       return EnumerableSet.Set._length(set._inner);
  //   }

  //   /**
  //    * @dev Returns the value stored at position `index` in the set. O(1).
  //    *
  //    * Note that there are no guarantees on the ordering of values inside the
  //    * array, and it may change when more values are added or removed.
  //    *
  //    * Requirements:
  //    *
  //    * - `index` must be strictly less than {length}.
  //    */
  //   function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
  //       return EnumerableSet.Set._at(set._inner, index);
  //   }

  // function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
  //   bytes4[] memory bytes4Array_;

  //     for( uint256 iteration_ = 0; EnumerableSet.Set._length( set_._inner ) >= iteration_; iteration_++ ){
  //       bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
  //     }

  //     return bytes4Array_;
  // }

  // function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
  //   return EnumerableSet.Set._insert( set_._inner, index_, valueToInsert_ );
  // }
}
