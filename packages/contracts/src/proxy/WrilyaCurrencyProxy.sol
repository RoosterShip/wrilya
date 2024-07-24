// SPDX-License-Identifier: GPL-3.0-or-later
//
// Copyright (C) 2024 Decentralized Consulting
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
pragma solidity >=0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../codegen/world/IWorld.sol";
import "../utils.sol";

contract WrilyaCurrencyProxy is IERC20 {
  address private _world;
  string private _name;
  string private _symbol;

  constructor(address world_, string memory name_, string memory symbol_) {
    // Verify that the address is a contract
    _world = world_;
    _name = name_;
    _symbol = symbol_;
  }

  /**
   * @dev Returns the name of the token.
   */
  function name() public view virtual returns (string memory) {
    return _name;
  }

  /**
   * @dev Returns the symbol of the token, usually a shorter version of the
   * name.
   */
  function symbol() public view virtual returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the MUD world address this contract proxies over
   */
  function world() public view virtual returns (address) {
    return _world;
  }

  /**
   * @dev Returns the number of decimals used to get its user representation.
   * For example, if `decimals` equals `2`, a balance of `505` tokens should
   * be displayed to a user as `5.05` (`505 / 10 ** 2`).
   *
   * Tokens usually opt for a value of 18, imitating the relationship between
   * Ether and Wei. This is the default value returned by this function, unless
   * it's overridden.
   *
   * NOTE: This information is only used for _display_ purposes: it in
   * no way affects any of the arithmetic of the contract, including
   * {IERC20-balanceOf} and {IERC20-transfer}.
   */
  function decimals() public view virtual returns (uint8) {
    return 18;
  }

  /**
   * @dev See {IERC20-totalSupply}.
   */
  function totalSupply() public view virtual returns (uint256) {
    //return _totalSupply;
    return uint256(0);
  }

  /**
   * @dev See {IERC20-balanceOf}.
   */
  //function balanceOf(address account) public view virtual returns (uint256) {
  function balanceOf(address account_) public view virtual returns (uint256) {
    return IWorld(_world).wrilya__ledgerTokenBalanceOf(toBytes32(account_));
  }

  /**
   * @dev See {IERC20-transfer}.
   *
   * Requirements:
   *
   * - `to` cannot be the zero address.
   * - the caller must have a balance of at least `value`.
   */
  //function transfer(address to, uint256 value) public virtual returns (bool) {
  function transfer(address, uint256) public virtual returns (bool) {
    //address owner = _msgSender();
    //_transfer(owner, to, value);
    //return true;
    return false;
  }

  /**
   * @dev See {IERC20-allowance}.
   */
  //function allowance(address owner, address spender) public view virtual
  // returns (uint256) {
  function allowance(address, address) public view virtual returns (uint256) {
    //return _allowances[owner][spender];
    return uint256(0);
  }

  /**
   * @dev See {IERC20-approve}.
   *
   * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
   * `transferFrom`. This is semantically equivalent to an infinite approval.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  //function approve(address spender, uint256 value) public virtual returns
  // (bool) {
  function approve(address, uint256) public virtual returns (bool) {
    // address owner = _msgSender();
    // _approve(owner, spender, value);
    // return true;
    return false;
  }

  /**
   * @dev See {IERC20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {ERC20}.
   *
   * NOTE: Does not update the allowance if the current allowance
   * is the maximum `uint256`.
   *
   * Requirements:
   *
   * - `from` and `to` cannot be the zero address.
   * - `from` must have a balance of at least `value`.
   * - the caller must have allowance for ``from``'s tokens of at least
   * `value`.
   */
  //function transferFrom(address from, address to, uint256 value) public
  // virtual returns (bool) {
  function transferFrom(
    address,
    address,
    uint256
  ) public virtual returns (bool) {
    //address spender = _msgSender();
    //_spendAllowance(from, spender, value);
    //_transfer(from, to, value);
    //return true;
    return false;
  }

  /**
   * @dev Moves a `value` amount of tokens from `from` to `to`.
   *
   * This internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * NOTE: This function is not virtual, {_update} should be overridden instead.
   */
  //function _transfer(address from, address to, uint256 value) internal {
  function _transfer(address, address, uint256) internal {
    // if (from == address(0)) {
    //     revert ERC20InvalidSender(address(0));
    // }
    // if (to == address(0)) {
    //     revert ERC20InvalidReceiver(address(0));
    // }
    // _update(from, to, value);
  }
}
