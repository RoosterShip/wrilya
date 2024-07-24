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

import {
  CurrencyConfig,
  CurrencyTuning,
  GameConfig,
  LedgerInfo
} from "./codegen/index.sol";
import "./utils.sol";
import "./errors.sol";
import {UD60x18, wrap, unwrap, UNIT} from "@prb/math/src/UD60x18.sol";

// ----------------------------------------------------------------------------
/**
 * @title Xchg
 * @author Chris Jimison
 * @notice Library of currency exchange operations
 */
library Xchg {
  /**
   * @dev Mint some new tokens to the receiver.
   *
   * Requirements:
   *
   * - the amount + total supply of tokens can not go over the max supply
   *
   * @param receiver to receiver the new tokens
   * @param amount_ of tokens to mint
   */
  function mint(bytes32 receiver, uint256 amount_) public {
    uint256 totalSupply = CurrencyConfig.getTotalSupply() + amount_;

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(CurrencyTuning.getMaxSupply() >= totalSupply, OutOfBounds());

    //---------------------------------
    // Logic Block
    //---------------------------------
    LedgerInfo.setTokens(receiver, LedgerInfo.getTokens(receiver) + amount_);
    CurrencyConfig.setTotalSupply(totalSupply);
  }

  /**
   * @dev Execute a buy order
   *
   * TODO:
   *
   * - Refactor to use TBC
   *
   * @param receiver_ to get the bought tokens
   * @param spend_ how much they are spending
   */
  function buy(bytes32 receiver_, uint256 spend_) public returns (uint256) {
    UD60x18 buyU = wrap(spend_);
    uint256 eth = CurrencyConfig.getLiquidity();
    UD60x18 ethU = wrap(eth);
    uint256 totalSupply = CurrencyConfig.getTotalSupply();
    UD60x18 tokensU = wrap(totalSupply);
    UD60x18 feeU = wrap(CurrencyTuning.getXchgFeeBuy());

    //---------------------------------
    // Pre Logic Block
    //---------------------------------

    // TODO:  Replace with TBC Implementation
    uint256 amt = unwrap((tokensU.div(ethU)).mul(buyU).mul(UNIT.sub(feeU)));
    uint256 newTotalSupply = totalSupply + amt;

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(newTotalSupply <= CurrencyTuning.getMaxSupply(), OutOfBounds());

    //---------------------------------
    // Logic Block
    //---------------------------------

    // Set the state based on the amount to mint
    LedgerInfo.setTokens(receiver_, LedgerInfo.getTokens(receiver_) + amt);
    CurrencyConfig.setTotalSupply(newTotalSupply);
    CurrencyConfig.setLiquidity(eth + spend_);

    return amt;
  }

  /**
   * @dev Sell some of the tokens owned by an account
   *
   * TODO:
   *
   * - Refactor to use TBC
   *
   * Requirments:
   *
   * - The acount has more then the given amount of tokens
   * - The system has enough liquidity base on the sale price
   *
   * @param account_ which has the tokens
   * @param amount_ of tokens to sell
   */
  function sell(bytes32 account_, uint256 amount_) public returns (uint256) {
    uint256 liquidity = CurrencyConfig.getLiquidity();
    uint256 totalSupply = CurrencyConfig.getTotalSupply();

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(LedgerInfo.getTokens(account_) >= amount_, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------

    // TODO:  Replace with TBC Implementation
    uint256 value =
      unwrap(wrap(liquidity).div(wrap(totalSupply)).mul(wrap(amount_)));

    CurrencyConfig.setLiquidity(liquidity - value);
    CurrencyConfig.setTotalSupply(totalSupply - amount_);
    return value;
  }
}
