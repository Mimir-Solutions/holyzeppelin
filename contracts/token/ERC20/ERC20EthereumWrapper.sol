// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "../../introspection/ERC1820/ERC1820EnhancedImplementer.sol";
import "./ERC20Burnable.sol";
import "../../security/Context.sol";

abstract contract ERC20EthereumWrapper is ERC20Burnable, ERC1820EnhancedImplementer {

  bytes32 immutable public ERC20_ETHEREUM_WRAPPER_INTERFACE_ID;

  constructor () {
    console.log("Instantiating ERC20EthereumWrapper.");

    console.log("Calculating ERC20_ETHEREUM_WRAPPER_INTERFACE_ID.");
    ERC20_ETHEREUM_WRAPPER_INTERFACE_ID = keccak256( "ERC20EthereumWrapper" );
    console.log("Calculated ERC20_ETHEREUM_WRAPPER_INTERFACE_ID.");
    console.log("ERC20_ETHEREUM_WRAPPER_INTERFACE_ID interface ID: %s", ERC20_ETHEREUM_WRAPPER_INTERFACE_ID);
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC20EthereumWrapper itself here
    console.log("Registering ERC20EthereumWrapper of %s for %s.", ERC20_ETHEREUM_WRAPPER_INTERFACE_ID, address(this));
    _registerInterfaceForAddress( ERC20_ETHEREUM_WRAPPER_INTERFACE_ID, address(this) );
    console.log("Registered ERC20EthereumWrapper.");

    console.log("Instantiated ERC20EthereumWrapper.");
  }

  fallback() external payable {
    wrap();
  }

  receive() external payable {
    wrap();
  }
  
  function wrap() public payable {
    _mint( Context._msgSender(), msg.value);
  }
  
  function unwrap( uint256 amountToUnwrap_ ) public {
    require( _balances[Context._msgSender()] >= amountToUnwrap_) ;
    _unwrap( amountToUnwrap_ );
  }

  function _unwrap( uint256 amountToUnwrap_ ) public {
    _burn( Context._msgSender(), amountToUnwrap_ );
    Context._msgSender().transfer(amountToUnwrap_);
  }

  function unwrapFrom( address account_, uint256 amountToUnwrap_ ) public {
    require( _balances[Context._msgSender()] >= amountToUnwrap_) ;
    uint256 decreasedAllowance_ = allowance( account_, Context._msgSender() ).sub( amountToUnwrap_, "ERC20: burn amount exceeds allowance");
    _approve( account_, Context._msgSender(), decreasedAllowance_ );
  }
}