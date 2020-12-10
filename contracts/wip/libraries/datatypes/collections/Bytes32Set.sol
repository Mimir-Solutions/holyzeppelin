// // // SPDX-License-Identifier: AGPL-3.0-or-later
// // pragma solidity 0.7.5;

// // import "./EnumerableSet.sol";

// library Bytes32Set {

//     using EnumerableSet for EnumerableSet.Set;

//     struct Set {
//         EnumerableSet.Set _inner;
//     }

//     /**
//      * @dev Add a value to a set. O(1).
//      *
//      * Returns true if the value was added to the set, that is if it was not
//      * already present.
//      */
//     function add(Set storage set, bytes32 value) internal returns ( bool ) {
//         return set._inner._add(value);
//     }

//     /**
//      * @dev Removes a value from a set. O(1).
//      *
//      * Returns true if the value was removed from the set, that is if it was
//      * present.
//      */
//     function remove(Set storage set, bytes32 value) internal returns ( bool ) {
//         return set._inner._remove(value);
//     }

//     /**
//      * @dev Returns true if the value is in the set. O(1).
//      */
//     function contains(Set storage set, bytes32 value) internal view returns ( bool ) {
//         return set._inner._contains(value);
//     }

//     /**
//      * @dev Returns the number of values on the set. O(1).
//      */
//     function length(Set storage set) internal view returns ( uint256 ) {
//         return set._inner._length();
//     }

//     /**
//      * @dev Returns the value stored at position `index` in the set. O(1).
//      *
//      * Note that there are no guarantees on the ordering of values inside the
//      * array, and it may change when more values are added or removed.
//      *
//      * Requirements:
//      *
//      * - `index` must be strictly less than {length}.
//      */
//     function at(Set storage set, uint256 index) internal view returns ( bytes32 ) {
//         return set._inner._at(index);
//     }
// }
