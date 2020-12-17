// // SPDX-License-Identifier: AGPL-3.0-or-later
// pragma solidity 0.8.0;

// import "../../dataTypes/collections/AddressSet.sol";
// import "../../dataTypes/collections/Bytes32Set.sol";

// // TODO: Better description
// // TODO: RoleData - approved bool should be a struct containing data about who approved etc. for more information .

// /**
//  * @notice Datatype for reuse in the authroization system.
//  */
// library RoleData {

//     using AddressSet for AddressSet.Set;
//     using Bytes32Set for Bytes32Set.Set;

//     struct Role {
//         bytes32 admin;
//         bytes32 approver;
//         AddressSet.Set members;
//         Bytes32Set.Set restrictedRoles;    // TODO: Loops are evil. Change data struct to some form of mapping?
//         mapping(address => bool) approved;
//     }

//     struct ContractRoles {
//         bytes32 root;
//         mapping(bytes32 => Role) roles;
//     }

// }
