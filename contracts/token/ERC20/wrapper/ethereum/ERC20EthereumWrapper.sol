// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "../../burnable/ERC20Burnable.sol";
import "../../../../security/Context.sol";
import "../../../../math/SafeMath.sol";
// import "../../datatypes/primitives/Bytes32.sol";

// TODO swithc to ERC777 with operator for transfering ETH to other pair.
abstract contract ERC20EthereumWrapper is ERC20Burnable {

  using SafeMath for uint256;
  // using Bytes32 for bytes32;

  bytes32 constant public ERC20_ETHEREUM_WRAPPER_INTERFACE_ID = keccak256( "ERC20EthereumWrapper" );

  constructor () {
    console.log("Instantiating ERC20EthereumWrapper.");

    console.log("ERC20_ETHEREUM_WRAPPER_INTERFACE_ID interface ID: %s", address( uint256( ERC20_ETHEREUM_WRAPPER_INTERFACE_ID ) ) );
    
    // Derived contracts need only register support for their own interfaces,
    // we register support for ERC20EthereumWrapper itself here
    console.log("Registering ERC20EthereumWrapper of %s for %s.", address( uint256( ERC20_ETHEREUM_WRAPPER_INTERFACE_ID ) ), address(this));
    _registerInterfaceForAddress( ERC20_ETHEREUM_WRAPPER_INTERFACE_ID, address(this) );
    console.log("Registered ERC20EthereumWrapper.");

    console.log("Instantiated ERC20EthereumWrapper.");
  }

  fallback() external payable virtual {
    _wrap( Context._msgSender() );
  }

  receive() external payable virtual {
    _wrap( Context._msgSender() );
  }

  function _wrap( address recipient_ ) public payable virtual {
    _mint( recipient_, msg.value);
  }
  
  function wrap() public payable virtual {
    _wrap( Context._msgSender() );
  }

  function wrapFor( address recipient_ ) public payable virtual {
    _wrap( recipient_ );
  }

  function _unwrap( address payable account_, uint256 amountToUnwrap_ ) public virtual {
    _burn( account_, amountToUnwrap_ );
    account_.transfer(amountToUnwrap_);
  }
  
  function unwrap( uint256 amountToUnwrap_ ) public virtual {
    require( _balances[Context._msgSender()] >= amountToUnwrap_) ;
    _unwrap( Context._msgSender(), amountToUnwrap_ );
  }

  function unwrapFrom( address payable account_, uint256 amountToUnwrap_ ) public virtual {
    require( _balances[Context._msgSender()] >= amountToUnwrap_);
    uint256 decreasedAllowance_ = allowance( account_, Context._msgSender() ).sub( amountToUnwrap_, "ERC20: burn amount exceeds allowance");
    _approve( account_, Context._msgSender(), decreasedAllowance_ );
    _unwrap( Context._msgSender(), amountToUnwrap_ );
  }
}