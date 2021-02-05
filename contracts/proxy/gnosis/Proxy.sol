/**
 *Submitted for verification at Etherscan.io on 2020-01-13
*/
// SPDX-License-Identifier: AGPL-3.0-or-later
// TODO find actual license
pragma solidity 0.7.5;

/// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
/// @author Stefan George - <stefan@gnosis.io>
/// @author Richard Meissner - <richard@gnosis.io>
contract Proxy {

    // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
    // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
    address internal _masterCopy;

    /// @dev Constructor function sets address of master copy contract.
    /// @param masterCopy_ Master copy address.
    constructor(address masterCopy_){
        require(_masterCopy != address(0), "Invalid master copy address provided");
        _masterCopy = masterCopy_;
    }

    /// @dev Fallback function forwards all transactions and returns all received return data.
    fallback()
        external
        payable
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
            // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
            if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
                mstore(0, masterCopy)
                return(0, 0x20)
            }
            calldatacopy(0, 0, calldatasize())
            let success := delegatecall(gas(), masterCopy, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            if eq(success, 0) { revert(0, returndatasize()) }
            return(0, returndatasize())
        }
    }
}