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

import {GameConfig, LedgerInfo, LedgerTuning} from "./codegen/index.sol";
import "./utils.sol";
import "./errors.sol";

// ----------------------------------------------------------------------------
/**
 * @title Ledger
 * @author Chris Jimison
 * @notice Library to interact with a users ledger values.
 */
library Ledger {
  /**
   * @dev Add to the amount of debit this person has.  This works kind of like
   * a general bucket.  You can fill up your "debit" bucket by so much, then
   * the game will charge you credits, then tokens.
   *
   * @param account_ to charge the player
   * @param amount_ amount to charge to the player
   */
  function bill(bytes32 account_, uint256 amount_) public {
    // TODO:  This code is ugle AF and should be cleaned up
    uint256 credits = LedgerInfo.getCredits(account_);
    uint256 tokens = LedgerInfo.getTokens(account_);
    uint256 debit = LedgerInfo.getDebit(account_);
    uint256 staked = LedgerInfo.getStaked(account_);
    uint256 baseDebit = LedgerTuning.getBaseDebit();

    uint256 maxDebit = baseDebit + staked;
    uint256 volDebit = maxDebit - debit;

    //---------------------------------
    // Verification Block
    //---------------------------------
    require((volDebit + credits + tokens) >= amount_, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------

    // let's try and fill up the debit amount first
    if (volDebit >= amount_) {
      LedgerInfo.setDebit(account_, debit + amount_);
    } else {
      // fill up the debit tank.
      // NOTE: optimization, don't write if value is already 0
      amount_ -= volDebit;
      LedgerInfo.setDebit(account_, maxDebit);

      // We need to pull from the credits next
      if (credits >= amount_) {
        LedgerInfo.setCredits(account_, credits - amount_);
      } else {
        // NOTE: Same optimization as above required
        LedgerInfo.setCredits(account_, 0);
        amount_ -= credits;
        LedgerInfo.setTokens(account_, tokens - amount_);
      }
    }
  }

  /**
   * @dev Give some credits to the ledger account holder.
   *
   * @param account_ to credit
   * @param amount_ to credit them with
   */
  function credit(bytes32 account_, uint256 amount_) public {
    LedgerInfo.setCredits(account_, LedgerInfo.getCredits(account_) + amount_);
  }

  /**
   * @dev Move an amount of tokens from the sender to the receiver
   *
   * Requirements:
   *
   * - sender must have amounts worth of tokens
   *
   * @param sender_ account to remove tokens from
   * @param receiver_ account to place tokens in
   * @param amount_ to move
   */
  function transfer(bytes32 sender_, bytes32 receiver_, uint256 amount_) public {
    uint256 sTokens = LedgerInfo.getTokens(sender_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(sTokens >= amount_, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------
    uint256 rTokens = LedgerInfo.getTokens(receiver_);
    LedgerInfo.setTokens(sender_, sTokens - amount_);
    LedgerInfo.setTokens(receiver_, rTokens + amount_);
  }

  /**
   * @dev Pay off an amount of debit for an account.  First it will pull from
   * the credit balance, then from the token balance.
   *
   * NOTE:
   *
   * If the payment amount is greater then the amount of debit owed it will only
   * pull the amount of debit, not the full passed in amount.
   *
   * Requirements:
   *
   * - The account has sufficient funds between the credits and tokens to pay
   * off the amount.
   *
   * @param account_ to make the payment
   * @param amount_ of debit that is requested to be payed
   */
  function payment(bytes32 account_, uint256 amount_) public {
    uint256 credits = LedgerInfo.getCredits(account_);
    uint256 tokens = LedgerInfo.getTokens(account_);
    uint256 debit = LedgerInfo.getDebit(account_);
    uint256 pay = debit > amount_ ? amount_ : debit;

    //---------------------------------
    // Verification Block
    //---------------------------------
    require((credits + tokens) >= pay, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------
    if (credits >= pay) {
      LedgerInfo.setCredits(account_, credits - pay);
    } else {
      // Bill the payer
      LedgerInfo.setCredits(account_, 0);
      uint256 delta = (pay - credits);
      LedgerInfo.setTokens(account_, tokens - delta);

      // Pay the system payee
      bytes32 payee = toBytes32(GameConfig.getPayee());
      uint256 pb = LedgerInfo.getTokens(payee);
      LedgerInfo.setTokens(payee, pb + delta);
    }

    // Wipe out whatever debit was payed
    LedgerInfo.setDebit(account_, debit - pay);
  }
}
