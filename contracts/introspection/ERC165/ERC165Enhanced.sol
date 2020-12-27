// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.6;

import "hardhat/console.sol";

import "./ERC165.sol";

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
 // TODO to define and provide function IDs based in call / delegateCall signatures.
/*
 *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
 *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
 *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
 *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
 *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
 *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
 *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
 *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
 *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
 *
 *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
 *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
 */
abstract contract ERC165Enhanced is IERC165Enhanced, ERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 immutable public ERC165_ENHANCED_INTERFACE_ID;

    bytes4[] private _supportedFunctionSelectors;

    constructor () {
      console.log("Instantiating ERC165Enhanced.");

      // Derived contracts need only register support for their own interfaces,
      // we register support for ERC165Enhanced itself here
      console.log("Calculating ERC165_ENHANCED_INTERFACE_ID.");
      ERC165_ENHANCED_INTERFACE_ID = bytes4(keccak256('supportedFunctionSelectors()'));
      console.log("Calculated ERC165_ENHANCED_INTERFACE_ID.");
      console.log("ERC165_ENHANCED_INTERFACE_ID interface ID: %s", ERC165_ENHANCED_INTERFACE_ID);
      console.log("Registering ERC165_ENHANCED_INTERFACE_ID.");
      _registerInterface(ERC165_ENHANCED_INTERFACE_ID);
      console.log("Registered ERC165_ENHANCED_INTERFACE_ID.");

      console.log("Registering function selector for supportedFunctionSelectorsSelector().");
      console.log("Function selector for supportedFunctionSelectorsSelector() is %s.", bytes4(keccak256('supportedFunctionSelectorsSelector()')));
      _registerFunctionSelector(bytes4(keccak256('supportedFunctionSelectors()')));
      console.log("Registered function selector for supportedFunctionSelectorsSelector().");

      console.log("Registering function selector for supportsInterface(bytes4).");
      console.log("Function selector for supportedFunctionSelectorsSelector() is %s.", bytes4(keccak256('supportsInterface(bytes4)')));
      _registerFunctionSelector(bytes4(keccak256('supportsInterface(bytes4)')));
      console.log("Registered function selector for supportsInterface(bytes4).");

      console.log("Instantiated ERC165Enhanced.");
    }

    function _registerFunctionSelector(bytes4 _functionSelectorToRegister) internal virtual {
      require(_functionSelectorToRegister != 0xffffffff, "ERC165Enhanced: invalid function selector id");
      _supportedFunctionSelectors.push(_functionSelectorToRegister);
    }

    function supportedFunctionSelectors() public returns (bytes4[]) {
      return _supportedFunctionSelectors;
    }
}