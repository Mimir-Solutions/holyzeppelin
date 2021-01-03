// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "../../security/Context.sol";
import "./IERC777.sol";
import "./IERC777Recipient.sol";
import "./IERC777Sender.sol";
import "../../token/ERC20/ERC20.sol";
import "../../math/SafeMath.sol";
import "../../datatypes/primitives/Address.sol";
import "../../introspection/ERC1820/interfaces/IERC1820Registry.sol";

/**
 * @dev Implementation of the {IERC777} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * Support for ERC20 is included in this contract, as specified by the EIP: both
 * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
 * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
 * movements.
 *
 * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
 * are no special restrictions in the amount of tokens that created, moved, or
 * destroyed. This makes integration with ERC20 applications seamless.
 */
contract ERC777 
  // is 
  // IERC777, 
  // ERC20 
{
  
  // using SafeMath for uint256;
  // using Address for address;

  // // IERC1820Registry immmutable internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

  // // Present in ERC20
  // // mapping(address => uint256) private _balances;

  // // Present in ERC20
  // // uint256 private _totalSupply;

  // // Present in ERC20
  // // string private _name;
  
  // // Present in ERC20
  // // string private _symbol;

  // // Present in ERC20
  // // uint8 private _decimals;
  
  // uint256 private _granularity;

  // // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
  // // See https://github.com/ethereum/solidity/issues/4024.
  // // This is has been addressed. keccak256 is now evaluated at compile time.

  // // 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895
  // bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH = keccak256( "ERC777TokensSender" );

  // // 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b
  // bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH = keccak256( "ERC777TokensRecipient" );

  // // This isn't ever read from - it's only used to respond to the defaultOperators query.
  // address[] private _defaultOperatorsArray;

  // // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
  // mapping(address => bool) private _defaultOperators;

  // // For each account, a mapping of its operators and revoked default operators.
  // mapping(address => mapping(address => bool)) private _operators;
  // mapping(address => mapping(address => bool)) private _revokedDefaultOperators;

  // // ERC20-allowances
  // // Present in ERC20
  // // mapping (address => mapping (address => uint256)) private _allowances;

  // /**
  //  * @dev `defaultOperators` may be an empty array.
  //  */
  // constructor(
  //   // Present in ERC20
  //   // string memory name_,
  //   // Present in ERC20
  //   // string memory symbol_,
  //   // Present in ERC20
  //   // uint8 memory decimals_,
  //   uint256 memory granularity_,
  //   address[] memory defaultOperators_
  // ) 
  //   // ERC20( name_, symbol_, decimals_ )
  // {
  //   // Present in ERC20
  //   // _name = name_;
  //   // Present in ERC20
  //   // _symbol = symbol_;
  //   // Present in ERC20
  //   // _decimals = decimals_;
  //   _granularity = granularity_;

  //   _defaultOperatorsArray = defaultOperators_;
  //   for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
  //     _defaultOperators[_defaultOperatorsArray[i]] = true;
  //   }

  //   // register interfaces
  //   // _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));1
  //   // _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
  // }

  // /**
  //  * @dev See {IERC777-name}.
  //  */
  // // Present in ERC20
  // // function name() public view override returns (string memory) {
  // //   return _name;
  // // }

  // /**
  //  * @dev See {IERC777-symbol}.
  //  */
  // // Present in ERC20
  // // function symbol() public view override returns (string memory) {
  // //   return _symbol;
  // // }

  // /**
  //  * @dev See {ERC20-decimals}.
  //  *
  //  * Always returns 18, as per the
  //  * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
  //  */
  // // Present in ERC20
  // // function decimals() public pure returns (uint8) {
  // //   return _decimals;
  // // }

  // /**
  //  * @dev See {IERC777-granularity}.
  //  */
  // function granularity() public pure override returns (uint256) {
  //   return _granularity;
  // }

  // /**
  //  * @dev See {IERC777-totalSupply}.
  //  */
  // // Present in ERC20
  // // function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
  // //   return _totalSupply;
  // // }

  // /**
  //  * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
  //  */
  // // Present in ERC20
  // // function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
  // //   return _balances[tokenHolder];
  // // }

  // /**
  //  * @dev Call from.tokensToSend() if the interface is registered
  //  * @param operator address operator requesting the transfer
  //  * @param from address token holder address
  //  * @param to address recipient address
  //  * @param amount uint256 amount of tokens to transfer
  //  * @param userData bytes extra information provided by the token holder (if any)
  //  * @param operatorData bytes extra information provided by the operator (if any)
  //  */
  // function _callTokensToSend(
  //   address operator,
  //   address from,
  //   address to,
  //   uint256 amount,
  //   bytes memory userData,
  //   bytes memory operatorData
  // ) internal virtual {
  //   address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
  //   if (implementer != address(0)) {
  //     IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
  //   }
  // }

  // function _callTokenTransferAmountAdjuster(
  //   address operator,
  //   address from,
  //   address to,
  //   uint256 amount,
  //   bytes memory userData,
  //   bytes memory operatorData
  // ) internal virtual returns (uint256) {
  //   address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
  //   uint256 transferAmountAdjustment_;
  //   if (implementer != address(0)) {
  //     transferAmountAdjustment_ = IERC777Adjuster(implementer).tokenTransferAmountToAdjust(operator, from, to, amount, userData, operatorData);
  //   }

  //   return transferAmountAdjustment_;
  // }

  // function _move(
  //   address operator,
  //   address from,
  //   address to,
  //   uint256 amount,
  //   bytes memory userData,
  //   bytes memory operatorData
  // ) internal override {
  //   _beforeTokenTransfer(operator, from, to, amount);

  //   _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
  //   _balances[to] = _balances[to].add(amount);

  //   emit Sent(operator, from, to, amount, userData, operatorData);
  //   emit Transfer(from, to, amount);
  // }

  // /**
  //  * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
  //  * tokensReceived() was not registered for the recipient
  //  * @param operator address operator requesting the transfer
  //  * @param from address token holder address
  //  * @param to address recipient address
  //  * @param amount uint256 amount of tokens to transfer
  //  * @param userData bytes extra information provided by the token holder (if any)
  //  * @param operatorData bytes extra information provided by the operator (if any)
  //  * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
  //  */
  // function _callTokensReceived(
  //   address operator,
  //   address from,
  //   address to,
  //   uint256 amount,
  //   bytes memory userData,
  //   bytes memory operatorData,
  //   bool requireReceptionAck
  // ) internal virtual {
  //   address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
  //   if (implementer != address(0)) {
  //     IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
  //   } else if (requireReceptionAck) {
  //     require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
  //   }
  // }

  // /**
  //  * @dev Send tokens
  //  * @param from address token holder address
  //  * @param to address recipient address
  //  * @param amount uint256 amount of tokens to transfer
  //  * @param userData bytes extra information provided by the token holder (if any)
  //  * @param operatorData bytes extra information provided by the operator (if any)
  //  * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
  //  */
  // function _send(
  //   address from,
  //   address to,
  //   uint256 amount,
  //   bytes memory userData,
  //   bytes memory operatorData,
  //   bool requireReceptionAck
  // ) internal virtual {
  //   require(from != address(0), "ERC777: send from the zero address");
  //   require(to != address(0), "ERC777: send to the zero address");

  //   address operator = Context._msgSender();

  //   uint256 transferAmountAdjustment_;

  //   _callTokensToSend(operator, from, to, amount, userData, operatorData);

  //   uint256 transferAmountAdjustment_ = _callTokenTransferAmountAdjuster(operator, from, to, amount, userData, operatorData);

  //   uint256 amountAfterAdjustment_ = amount.sub(transferAmountAdjustment_);

  //   _move(operator, from, to, amountAfterAdjustment_, userData, operatorData);

  //   _callTokensReceived(operator, from, to, amountAfterAdjustment_, userData, operatorData, requireReceptionAck);
  // }

  // /**
  //  * @dev See {IERC777-send}.
  //  *
  //  * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
  //  */
  // function send(address recipient, uint256 amount, bytes memory data) public virtual override  {
  //   _send(Context._msgSender(), recipient, amount, data, "", true);
  // }

  // /**
  //  * @dev See {IERC20-transfer}.
  //  *
  //  * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
  //  * interface if it is a contract.
  //  *
  //  * Also emits a {Sent} event.
  //  */
  // // Override of ERC20
  // function _transfer(address recipient, uint256 amount) public virtual override returns (bool) {
  //   _send(Context._msgSender(), recipient, amount, "", "", false);

  //   // TriaLing reusing _send for _transfer;

  //   // require(recipient != address(0), "ERC777: transfer to the zero address");

  //   // address from = Context._msgSender();

  //   // _callTokensToSend(from, from, recipient, amount, "", "");

  //   // _move(from, from, recipient, amount, "", "");

  //   // _callTokensReceived(from, from, recipient, amount, "", "", false);

  //   return true;
  // }

  // /**
  //    * @dev See {IERC777-burn}.
  //    *
  //    * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
  //    */
  //   function burn(uint256 amount, bytes memory data) public virtual override  {
  //       _burn(Context._msgSender(), amount, data, "");
  //   }

  //   /**
  //    * @dev See {IERC777-isOperatorFor}.
  //    */
  //   function isOperatorFor(
  //       address operator,
  //       address tokenHolder
  //   ) public view virtual override returns (bool) {
  //       return operator == tokenHolder ||
  //           (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
  //           _operators[tokenHolder][operator];
  //   }

  //   /**
  //    * @dev See {IERC777-authorizeOperator}.
  //    */
  //   function authorizeOperator(address operator) public virtual override  {
  //       require(Context._msgSender() != operator, "ERC777: authorizing self as operator");

  //       if (_defaultOperators[operator]) {
  //           delete _revokedDefaultOperators[Context._msgSender()][operator];
  //       } else {
  //           _operators[Context._msgSender()][operator] = true;
  //       }

  //       emit AuthorizedOperator(operator, Context._msgSender());
  //   }

  //   /**
  //    * @dev See {IERC777-revokeOperator}.
  //    */
  //   function revokeOperator(address operator) public virtual override  {
  //       require(operator != Context._msgSender(), "ERC777: revoking self as operator");

  //       if (_defaultOperators[operator]) {
  //           _revokedDefaultOperators[Context._msgSender()][operator] = true;
  //       } else {
  //           delete _operators[Context._msgSender()][operator];
  //       }

  //       emit RevokedOperator(operator, Context._msgSender());
  //   }

  //   /**
  //    * @dev See {IERC777-defaultOperators}.
  //    */
  //   function defaultOperators() public view virtual override returns (address[] memory) {
  //       return _defaultOperatorsArray;
  //   }

  //   /**
  //    * @dev See {IERC777-operatorSend}.
  //    *
  //    * Emits {Sent} and {IERC20-Transfer} events.
  //    */
  //   function operatorSend(
  //       address sender,
  //       address recipient,
  //       uint256 amount,
  //       bytes memory data,
  //       bytes memory operatorData
  //   )
  //   public virtual override
  //   {
  //       require(isOperatorFor(Context._msgSender(), sender), "ERC777: caller is not an operator for holder");
  //       _send(sender, recipient, amount, data, operatorData, true);
  //   }

  //   /**
  //    * @dev See {IERC777-operatorBurn}.
  //    *
  //    * Emits {Burned} and {IERC20-Transfer} events.
  //    */
  //   function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public virtual override {
  //       require(isOperatorFor(Context._msgSender(), account), "ERC777: caller is not an operator for holder");
  //       _burn(account, amount, data, operatorData);
  //   }

  //   /**
  //    * @dev See {IERC20-allowance}.
  //    *
  //    * Note that operator and allowance concepts are orthogonal: operators may
  //    * not have allowance, and accounts with allowance may not be operators
  //    * themselves.
  //    */
  //   function allowance(address holder, address spender) public view virtual override returns (uint256) {
  //       return _allowances[holder][spender];
  //   }

  //   /**
  //    * @dev See {IERC20-approve}.
  //    *
  //    * Note that accounts cannot have allowance issued by their operators.
  //    */
  //   function approve(address spender, uint256 value) public virtual override returns (bool) {
  //       address holder = Context._msgSender();
  //       _approve(holder, spender, value);
  //       return true;
  //   }

  //  /**
  //   * @dev See {IERC20-transferFrom}.
  //   *
  //   * Note that operator and allowance concepts are orthogonal: operators cannot
  //   * call `transferFrom` (unless they have allowance), and accounts with
  //   * allowance cannot call `operatorSend` (unless they are operators).
  //   *
  //   * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
  //   */
  //   function transferFrom(address holder, address recipient, uint256 amount) public virtual override returns (bool) {
  //       require(recipient != address(0), "ERC777: transfer to the zero address");
  //       require(holder != address(0), "ERC777: transfer from the zero address");

  //       address spender = Context._msgSender();

  //       _callTokensToSend(spender, holder, recipient, amount, "", "");

  //       _move(spender, holder, recipient, amount, "", "");
  //       _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));

  //       _callTokensReceived(spender, holder, recipient, amount, "", "", false);

  //       return true;
  //   }

  //   /**
  //    * @dev Creates `amount` tokens and assigns them to `account`, increasing
  //    * the total supply.
  //    *
  //    * If a send hook is registered for `account`, the corresponding function
  //    * will be called with `operator`, `data` and `operatorData`.
  //    *
  //    * See {IERC777Sender} and {IERC777Recipient}.
  //    *
  //    * Emits {Minted} and {IERC20-Transfer} events.
  //    *
  //    * Requirements
  //    *
  //    * - `account` cannot be the zero address.
  //    * - if `account` is a contract, it must implement the {IERC777Recipient}
  //    * interface.
  //    */
  //   function _mint(
  //       address account,
  //       uint256 amount,
  //       bytes memory userData,
  //       bytes memory operatorData
  //   )
  //   internal virtual
  //   {
  //       require(account != address(0), "ERC777: mint to the zero address");

  //       address operator = Context._msgSender();

  //       _beforeTokenTransfer(operator, address(0), account, amount);

  //       // Update state variables
  //       _totalSupply = _totalSupply.add(amount);
  //       _balances[account] = _balances[account].add(amount);

  //       _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);

  //       emit Minted(operator, account, amount, userData, operatorData);
  //       emit Transfer(address(0), account, amount);
  //   }

    
  //   /**
  //    * @dev Burn tokens
  //    * @param from address token holder address
  //    * @param amount uint256 amount of tokens to burn
  //    * @param data bytes extra information provided by the token holder
  //    * @param operatorData bytes extra information provided by the operator (if any)
  //    */
  //   function _burn(
  //       address from,
  //       uint256 amount,
  //       bytes memory data,
  //       bytes memory operatorData
  //   )
  //       internal virtual
  //   {
  //       require(from != address(0), "ERC777: burn from the zero address");

  //       address operator = Context._msgSender();

  //       _beforeTokenTransfer(operator, from, address(0), amount);

  //       _callTokensToSend(operator, from, address(0), amount, data, operatorData);

  //       // Update state variables
  //       _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
  //       _totalSupply = _totalSupply.sub(amount);

  //       emit Burned(operator, from, amount, data, operatorData);
  //       emit Transfer(from, address(0), amount);
  //   }

  //   /**
  //    * @dev See {ERC20-_approve}.
  //    *
  //    * Note that accounts cannot have allowance issued by their operators.
  //    */
  //   function _approve(address holder, address spender, uint256 value) internal virtual override {
  //       require(holder != address(0), "ERC777: approve from the zero address");
  //       require(spender != address(0), "ERC777: approve to the zero address");

  //       _allowances[holder][spender] = value;
  //       emit Approval(holder, spender, value);
  //   }

    

  //   /**
  //    * @dev Hook that is called before any token transfer. This includes
  //    * calls to {send}, {transfer}, {operatorSend}, minting and burning.
  //    *
  //    * Calling conditions:
  //    *
  //    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
  //    * will be to transferred to `to`.
  //    * - when `from` is zero, `amount` tokens will be minted for `to`.
  //    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
  //    * - `from` and `to` are never both zero.
  //    *
  //    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
  //    */
  //   function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual override { }
}
