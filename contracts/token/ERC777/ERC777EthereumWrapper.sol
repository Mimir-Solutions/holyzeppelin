// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "../ERC20/ERC20Burnable.sol";
import "../ERC20/ERC20EthereumWrapper.sol";
import "../../security/Context.sol";
import "../../math/SafeMath.sol";
import "../../datatypes/primitives/Bytes32.sol";
import "./ERC777.sol";

abstract contract ERC777EthereumWrapper is ERC777, ERC20EthereumWrapper {

  using SafeMath for uint256;
  using Bytes32 for bytes32;

  bytes32 constant public ERC777_ETHEREUM_WRAPPER_ERC1820_INTERFACE_ID = keccak256( "ERC777EthereumWrapper" );

  constructor () {
    console.log("Instantiating ERC777EthereumWrapper.");

    console.log("ERC777_ETHEREUM_WRAPPER_INTERFACE_ID interface ID: %s", ERC777_ETHEREUM_WRAPPER_ERC1820_INTERFACE_ID.toString() );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC20EthereumWrapper itself here
    console.log("Registering ERC777EthereumWrapper of %s for %s.", ERC777_ETHEREUM_WRAPPER_ERC1820_INTERFACE_ID.toString(), address(this));
    _registerInterfaceForAddress( ERC777_ETHEREUM_WRAPPER_ERC1820_INTERFACE_ID, address(this) );
    console.log("Registered ERC777EthereumWrapper.");

    console.log("Instantiated ERC777EthereumWrapper.");
  }
  
  fallback() external payable virtual override {
    _wrap( Context._msgSender() );
  }

  receive() external payable virtual override {
    _wrap( Context._msgSender() );
  }

  function _wrap( address recipient_ ) public payable virtual override {
    _mint( recipient_, msg.value);
  }
  
  function wrap() public payable virtual override {
    _wrap( Context._msgSender() );
  }

  function wrapFor( address recipient_ ) public payable virtual override {
    _wrap( recipient_ );
  }

  function _unwrap( address payable account_, uint256 amountToUnwrap_ ) public virtual override {
    _burn( account_, amountToUnwrap_);
    account_.transfer(amountToUnwrap_);
  }
  
  function unwrap( uint256 amountToUnwrap_ ) public virtual override {
    require( _balances[Context._msgSender()] >= amountToUnwrap_) ;
    _unwrap( Context._msgSender(), amountToUnwrap_ );
  }

  function unwrapFrom( uint256 amountToUnwrap_, address account_ ) public virtual {
    require( _balances[Context._msgSender()] >= amountToUnwrap_) ;
    uint256 decreasedAllowance_ = allowance( account_, Context._msgSender() ).sub( amountToUnwrap_, "ERC20: burn amount exceeds allowance");
    _approve( account_, Context._msgSender(), decreasedAllowance_ );
    _unwrap( Context._msgSender(), amountToUnwrap_ );
  }
}