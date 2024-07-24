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

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------

import {System} from "@latticexyz/world/src/System.sol";
import {WorldResourceIdLib} from "@latticexyz/world/src/WorldResourceId.sol";
import {ResourceId} from "@latticexyz/store/src/ResourceId.sol";
import "../codegen/index.sol";
import "../codegen/common.sol";
import "../codegen/world/IWorld.sol";
import "../errors.sol";
import "../utils.sol";
import "../checks.sol";
import "../ledger.sol";
import "../constants.sol";
import "../xchg.sol";

// ----------------------------------------------------------------------------
/// @title CurrencySystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract CurrencySystem is System {
  /**
   * @dev Mint tokens into the Governor Contract for future distribution
   *
   * Requirements:
   *
   * - Only the governor can mint tokens
   * - The amount to mint must be greater then zero
   * - Value of mint must be greater then 1
   *
   * @param amount_ of tokens to mint
   */
  function currencyMint(uint256 amount_) public payable {
    address gov = GameConfig.getGovernor();
    uint256 value = _msgValue();

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == gov, Unauthorized());
    require(amount_ > 0, InvalidArgument());
    require(value > 0, MissingPayment());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Xchg.mint(toBytes32(gov), amount_);
    CurrencyConfig.setLiquidity(CurrencyConfig.getLiquidity() + value);
  }

  /**
   * @dev Pause The Currency Exchange
   *
   * Requirements:
   *
   * - Only the governor can pause
   */
  function currencyXchgPause() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(CurrencyConfig.getXchgActive(), SystemActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyConfig.setXchgActive(false);
  }

  /**
   * @dev Run The currency exchange
   *
   * Requirements:
   *
   * - Only the governor can run the exchange
   */
  function currencyXchgRun() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(!CurrencyConfig.getXchgActive(), SystemActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    CurrencyConfig.setXchgActive(true);
  }

  /**
   * @dev Purchase game tokens for native game tokens.
   *
   * Requirements:
   *
   * - The exchange is active
   * - Caller can not be on any banned list
   *
   */
  function currencyXchgBuy() public payable returns (uint256) {
    address caller = _msgSender();

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(CurrencyConfig.getXchgActive(), SystemActiveState());
    require(!isBanned(caller), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    return Xchg.buy(toBytes32(caller), _msgValue());
  }

  /**
   * @dev Sell/Burn a given amount of tokens and receive ETH for them.
   *
   * Requirements:
   *
   * - Caller can not be on any banned list
   * - Caller must have the full amount of tokens in there account
   *
   * @param amount_ of tokens to be burned
   */
  function currencyXchgSell(uint256 amount_) public returns (uint256) {
    address caller = _msgSender();
    bytes32 entity = toBytes32(caller);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(CurrencyConfig.getXchgActive(), SystemActiveState());
    require(!isBanned(caller), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    uint256 retAmt = Xchg.sell(entity, amount_);
    IWorld(_world()).transferBalanceToAddress(
      WorldResourceIdLib.encodeNamespace(bytes14("wrilya")), caller, retAmt
    );
    return retAmt;
  }
}
