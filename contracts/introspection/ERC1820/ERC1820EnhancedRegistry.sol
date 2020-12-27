// // SPDX-License-Identifier: MIT
// pragma solidity 0.7.6;
// import "hardhat/console.sol";

// import "../ERC165/ERC165.sol";
// import "./ERC1820Implementer.sol";
// import "./ERC1820Registry.sol";
// import "../../security/Context.sol";

// /**
//  * @dev Interface of the global ERC1820 Registry, as defined in the
//  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
//  * implementers for interfaces in this registry, as well as query support.
//  *
//  * Implementers may be shared by multiple accounts, and can also implement more
//  * than a single interface for each account. Contracts can implement interfaces
//  * for themselves, but externally-owned accounts (EOA) must delegate this to a
//  * contract.
//  *
//  * {IERC165} interfaces can also be queried via the registry.
//  *
//  * For an in-depth explanation and source code analysis, see the EIP text.
//  */
// contract ERC1820EnhancedRegistry is ERC1820Registry, ERC1820EnhancedRegistar {

//   bytes4 immutable public ERC1820_REGISTRY_INTERFACE_ERC165_ID;

//   constructor () {
//     console.log("Instantiating ERC1820EnhancedRegistry.");

//     console.log("Calculating ERC1820_REGISTRY_INTERFACE_ERC165_ID.");
//     ERC1820_REGISTRY_INTERFACE_ERC165_ID = 
//       bytes4(keccak256("setManager(address,address)"))
//       ^ bytes4(keccak256("getManager(address)"))
//       ^ bytes4(keccak256("setInterfaceImplementer(address,bytes32,address)"))
//       ^ bytes4(keccak256("getInterfaceImplementer(address,bytes32)"))
//       ^ bytes4(keccak256("interfaceHash(string calldata interfaceName)"))
//       ^ bytes4(keccak256("updateERC165Cache(address,bytes4)"))
//       ^ bytes4(keccak256("implementsERC165Interface(address,bytes4)"))
//       ^ bytes4(keccak256("implementsERC165InterfaceNoCache(address,bytes4)"));
//     console.log("Calculated ERC1820_REGISTRY_INTERFACE_ERC165_ID.");
//     console.log("ERC1820_REGISTRY_INTERFACE_ERC165_ID interface ID: %s", ERC1820_REGISTRY_INTERFACE_ERC165_ID);

//     console.log("Registering ERC1820Registry ERC165 interface ID.");
//     console.log("ERC1820Registry interface ERC165 ID: %s", ERC1820_REGISTRY_INTERFACE_ERC165_ID);
//     _registerInterface( ERC1820_REGISTRY_INTERFACE_ERC165_ID );
//     console.log("Registered ERC1820Registry ERC165 interface ID.");

//     console.log("Registering ERC1820Registry ERC165 interface ID of %s for %s.", ERC1820_REGISTRY_INTERFACE_ERC165_ID, address(this));
//     _registerInterfaceForAddress( ERC1820_REGISTRY_INTERFACE_ERC165_ID, address(this) );
//     console.log("Registered ERC1820Registry ERC165 interface ID.");

//     console.log("Registering ERC165 ERC165 interface ID.");
//     console.log("ERC165 interface ERC165 ID: %s", ERC165_INTERFACE_ID);
//     _registerERC165CompliantInterfaceID( address(this), ERC165_INTERFACE_ID);
//     console.log("Registered ERC165 ERC165 interface ID.");

//     console.log("Registering ERC1820Implementer ERC165 interface ID.");
//     console.log("ERC1820Implementer interface ID: %s", ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID);
//     _registerERC165CompliantInterfaceID( address(this), ERC1820_IMPLEMENTER_INTERFACE_ERC165_ID);
//     console.log("Registered ERC1820Implementer ERC165 interface ID.");

//     console.log("Registering ERC1820Registry ERC165 interface ID.");
//     console.log("ERC1820Registry ERC165 interface ID: %s", ERC1820_REGISTRY_INTERFACE_ERC165_ID);
//     _registerERC165CompliantInterfaceID( address(this), ERC1820_REGISTRY_INTERFACE_ERC165_ID);
//     console.log("Registered ERC1820Registry ERC165 interface ID.");

//     console.log("Registering ERC165 ERC1820 interface ID of %s for %s.", ERC165_INTERFACE_ERC1820_ID, address(this));
//     _registerERC1820CompliantInterfaceID( ERC165_INTERFACE_ERC1820_ID, address(this) );
//     console.log("Registered ERC165 ERC1820 interface ID.");

//     console.log("Instantiated ERC1820EnhancedRegistry.");
//   }
// }
