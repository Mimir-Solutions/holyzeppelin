// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;
import "hardhat/console.sol";

import "./interfaces/IERC1820Registry.sol";
import "./ERC1820Registrar.sol";
import "../../security/Context.sol";
import "../../datatypes/primitives/Address.sol";

/**
 * @dev Interface of the global ERC1820 Registry, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
 * implementers for interfaces in this registry, as well as query support.
 *
 * Implementers may be shared by multiple accounts, and can also implement more
 * than a single interface for each account. Contracts can implement interfaces
 * for themselves, but externally-owned accounts (EOA) must delegate this to a
 * contract.
 *
 * {IERC165} interfaces can also be queried via the registry.
 *
 * For an in-depth explanation and source code analysis, see the EIP text.
 */
contract ERC1820Registry is IERC1820Registry, ERC1820Registrar {

  using Address for address;

  // @notice Indicates a contract is the 'implementer' of 'interfaceHash' for 'addr'.
  // event InterfaceImplementerSet(address indexed addr, bytes32 indexed interfaceHash, address indexed implementer);
  //  Indicates 'newManager' is the address of the new manager for 'addr'.
  // event ManagerChanged(address indexed addr, address indexed newManager);

  // ERC165 Invalid ID.
  bytes4 constant internal INVALID_ID = 0xffffffff;
  // Method ID for the ERC165 supportsInterface method (= `bytes4(keccak256('supportsInterface(bytes4)'))`).
  bytes4 constant internal ERC165ID = 0x01ffc9a7;
  // Magic value which is returned if a contract implements an interface on behalf of some other address.
  // bytes32 constant internal ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

  bytes32 constant public ERC1820_REGISTRY_INTERFACE_ID = keccak256("ERC1820Registry");

  //  mapping from addresses and interface hashes to their implementers.
  mapping(address => mapping(bytes32 => address)) internal interfaces;
  //  mapping from addresses to their manager.
  mapping(address => address) internal managers;
  //  flag for each address and erc165 interface to indicate if it is cached.
  mapping(address => mapping(bytes4 => bool)) internal erc165Cached;

  constructor() ERC1820Registrar() {
    console.log("Instantiating ERC1820Registry.");

    console.log("ERC1820_REGISTRY_INTERFACE_ID interface ID: %s", address( uint256( ERC1820_REGISTRY_INTERFACE_ID) ) );

    _addERC1820InterfaceIDToSelf( ERC1820_REGISTRY_INTERFACE_ID );

    console.log( "ERC1820Registrar::constructor:7 Saving registry manager of %s.",  msg.sender );
    _setRegistryManager( msg.sender );
    console.log( "ERC1820Registrar::constructor:8 Saved registry manager of %s.", registryManager );

    console.log( "Registering interfaces wiht self." );
    _registerInterfacesWithSelf();
    console.log( "Registered interfaces wiht self." );

    // _addRegistry( address(this) );
    
    // console.log( "Registering interfaces wiht external registries." );
    // _registerWithRegisties();
    // console.log( "Registered interfaces wiht external registries." );

    console.log("Instantiated ERC1820Registry.");
  }

    // Sets the contract which implements a specific interface for an address.
    /// Only the manager defined for that address can set it.
    /// (Each address is the manager for itself until it sets a new manager.)
    /// @param _addr Address for which to set the interface.
    /// (If '_addr' is the zero address then 'msg.sender' is assumed.)
    /// @param _interfaceHash Keccak256 hash of the name of the interface as a string.
    /// E.g., 'web3.utils.keccak256("ERC777TokensRecipient")' for the 'ERC777TokensRecipient' interface.
    /// @param _implementer Contract address implementing '_interfaceHash' for '_addr'.
    function setInterfaceImplementer( address _addr, bytes32 _interfaceHash, address _implementer ) external override {
      address addr = _addr == address(0) ? msg.sender : _addr;
      require(_getManager(addr) == msg.sender, "Not the manager");
      _setInterfaceImplementer( _addr, _interfaceHash, _implementer );
    }

  function _setInterfaceImplementer(address addr_, bytes32 _interfaceHash, address _implementer) internal virtual {
    require( _implementer.isContract() );
    require(!isERC165Interface(_interfaceHash), "Must not be an ERC165 hash");
    if (_implementer != address(0) && _implementer != msg.sender) {
      require( _doesImplementsERC1820Interface( _implementer, addr_, _interfaceHash )
        // Was previous evaluation. Moved to own internal function for reuse.
        // IERC1820Implementer(_implementer).canImplementInterfaceForAddress(_interfaceHash, addr) == ERC1820_ACCEPT_MAGIC
          ,"Does not implement the interface"
        );
    }
    interfaces[addr_][_interfaceHash] = _implementer;
    emit InterfaceImplementerSet(addr_, _interfaceHash, _implementer);
  }

  function _doesImplementsERC1820Interface( address implementer_, address addressToVerify_, bytes32 interfaceToVerify_ ) internal view returns ( bool ) {
    return ( IERC1820Implementer(implementer_).canImplementInterfaceForAddress(interfaceToVerify_, addressToVerify_) == ERC1820_ACCEPT_MAGIC );
  }

    // Sets '_newManager' as manager for '_addr'.
    /// The new manager will be able to call 'setInterfaceImplementer' for '_addr'.
    /// @param _addr Address for which to set the new manager.
    /// @param _newManager Address of the new manager for 'addr'. (Pass '0x0' to reset the manager to '_addr'.)
    function setManager(address _addr, address _newManager) external override {
         _setManager( _addr, _newManager );
    }

    function _setManager(address _addr, address _newManager) internal {
        require(_getManager(_addr) == msg.sender, "Not the manager");
        managers[_addr] = _newManager == _addr ? address(0) : _newManager;
        emit ManagerChanged(_addr, _newManager);
    }

    // Get the manager of an address.
    /// @param _addr Address for which to return the manager.
    /// @return Address of the manager for a given address.
    function getManager(address _addr) external view virtual override returns(address) {
        return _getManager( _addr );
    }
    function _getManager(address _addr) internal view virtual returns(address) {
        // By default the manager of an address is the same address
        if (managers[_addr] == address(0)) {
            return _addr;
        } else {
            return managers[_addr];
        }
    }

    // Compute the keccak256 hash of an interface given its name.
    /// @param _interfaceName Name of the interface.
    /// @return The keccak256 hash of an interface name.
    function interfaceHash(string calldata _interfaceName) external pure override returns(bytes32) {
        return keccak256(abi.encodePacked(_interfaceName));
    }

    /* --- ERC165 Related Functions --- */
    /* --- Developed in collaboration with William Entriken. --- */

    // Updates the cache with whether the contract implements an ERC165 interface or not.
    /// @param _contract Address of the contract for which to update the cache.
    /// @param _interfaceId ERC165 interface for which to update the cache.
    function updateERC165Cache(address _contract, bytes4 _interfaceId) external override {
        interfaces[_contract][_interfaceId] = implementsERC165InterfaceNoCache(
            _contract, _interfaceId) ? _contract : address(0);
        erc165Cached[_contract][_interfaceId] = true;
    }

    //Checks whether a contract implements an ERC165 interface or not.
    //  If the result is not cached a direct lookup on the contract address is performed.
    //  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
    //  'updateERC165Cache' with the contract address.
    /// @param _contract Address of the contract to check.
    /// @param _interfaceId ERC165 interface to check.
    /// @return True if '_contract' implements '_interfaceId', false otherwise.
    function implementsERC165Interface(address _contract, bytes4 _interfaceId) public view override returns (bool) {
        if (!erc165Cached[_contract][_interfaceId]) {
            return implementsERC165InterfaceNoCache(_contract, _interfaceId);
        }
        return interfaces[_contract][_interfaceId] == _contract;
    }

    // Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
    /// @param _contract Address of the contract to check.
    /// @param _interfaceId ERC165 interface to check.
    /// @return True if '_contract' implements '_interfaceId', false otherwise.
    function implementsERC165InterfaceNoCache(address _contract, bytes4 _interfaceId) public view override returns (bool) {
        uint256 success;
        uint256 result;

        (success, result) = noThrowCall(_contract, ERC165ID);
        if (success == 0 || result == 0) {
            return false;
        }

        (success, result) = noThrowCall(_contract, INVALID_ID);
        if (success == 0 || result != 0) {
            return false;
        }

        (success, result) = noThrowCall(_contract, _interfaceId);
        if (success == 1 && result == 1) {
            return true;
        }
        return false;
    }

    // Checks whether the hash is a ERC165 interface (ending with 28 zeroes) or not.
    /// @param _interfaceHash The hash to check.
    /// @return True if '_interfaceHash' is an ERC165 interface (ending with 28 zeroes), false otherwise.
    function isERC165Interface(bytes32 _interfaceHash) internal pure returns (bool) {
        return _interfaceHash & 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0;
    }

    /// @dev Make a call on a contract without throwing if the function does not exist.
    function noThrowCall(address _contract, bytes4 _interfaceId)
        internal view returns (uint256 success, uint256 result)
    {
        bytes4 erc165ID = ERC165ID;

        assembly {
            let x := mload(0x40)               // Find empty storage location using "free memory pointer"
            mstore(x, erc165ID)                // Place signature at beginning of empty storage
            mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature

            success := staticcall(
                30000,                         // 30k gas
                _contract,                     // To addr
                x,                             // Inputs are stored at location x
                0x24,                          // Inputs are 36 (4 + 32) bytes long
                x,                             // Store output over input (saves space)
                0x20                           // Outputs are 32 bytes long
            )

            result := mload(x)                 // Load the result
        }
    }

  /**
   * @dev Returns the implementer of `interfaceHash` for `account`. If no such
   * implementer is registered, returns the zero address.
   *
   * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
   * zeroes), `account` will be queried for support of it.
   *
   * `account` being the zero address is an alias for the caller's address.
   */
  function getInterfaceImplementer(address account, bytes32 interfaceHash_) external view override returns ( address ) {
    return interfaces[account][interfaceHash_];
  }
}