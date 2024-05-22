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
pragma solidity >=0.8.24;

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------

import { System } from "@latticexyz/world/src/System.sol";
import { CurrencyTable, CurrencyTableData, GameConfigTable } from "../codegen/index.sol";
import { toBytes32, requireRunning, notify } from "../utils.sol";
import { OperationEnum } from "../codegen/common.sol";
import { InvalidState, InsufficientFunds } from "../errors.sol";

// ----------------------------------------------------------------------------
/// @title GameSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract CurrencySystem is System {

  function mint(uint256 amount) public {
    // Verification Phase
    requireRunning();
    bytes32 owner = toBytes32(_msgSender());
    CurrencyTable.setTokens(owner, CurrencyTable.getTokens(owner) + amount);
    notify(OperationEnum.CURRENCY_MINT, abi.encode(owner, amount));
  }

  function stake(uint256 amount) public {
    // Verification of 
    requireRunning();

    // Verify that user has enough funds
    bytes32 owner = toBytes32(_msgSender());
    uint256 tokens = CurrencyTable.getTokens(owner);
    if(tokens < amount) revert InsufficientFunds();

    // Set the state info
    CurrencyTable.setTokens(owner, tokens - amount);
    uint256 staked = CurrencyTable.getStaked(owner);
    CurrencyTable.setStaked(owner, staked + amount);
    
    notify(OperationEnum.CURRENCY_STAKE, abi.encode(owner, amount));
  }

  function release(uint256 amount) public {
    // Verification of 
    requireRunning();

    // Verify that user has enough funds
    bytes32 owner = toBytes32(_msgSender());
    CurrencyTableData memory acc = CurrencyTable.get(owner);
    if(acc.staked < amount) revert InsufficientFunds();

    // Claim any staked tokens
    if(acc.uts <= block.timestamp && acc.unstaked > 0){
      // Let's run a claim first
      acc.tokens += acc.unstaked;
      acc.unstaked = 0;
    }
    else if (acc.unstaked > 0){
      revert InvalidState();
    }

    acc.unstaked = amount;
    acc.staked -= amount;

    acc.uts = block.timestamp + GameConfigTable.getCurrencyUnstakeTime();

    CurrencyTable.set(owner, acc); 

    notify(OperationEnum.CURRENCY_RELEASE, abi.encode(owner, amount));
  }

  function claim() public {
    // Verification of 
    requireRunning();

    // Verify that user has enough funds
    bytes32 owner = toBytes32(_msgSender());
    CurrencyTableData memory acc = CurrencyTable.get(owner);

    if(acc.uts <= block.timestamp && acc.unstaked > 0){
      // Let's run a claim first
      acc.tokens += acc.unstaked;
      acc.unstaked = 0;
    }
    else {
      revert InvalidState();
    }

    notify(OperationEnum.CURRENCY_CLAIM, abi.encode(owner));
  }

  /**
   * Make a payment to reduce debit.  This will come from the credits balance
   * first and then from the tokens balance.
   * 
   * @param amount to pay off.
   */
  function payment(uint256 amount) public {
    // Verification Phase
    requireRunning();

    bytes32 owner = toBytes32(_msgSender());
    CurrencyTableData memory acc = CurrencyTable.get(owner);
    if(acc.debit < amount){
      amount = acc.debit;
    }

    if(acc.credits > 0 && acc.credits >= amount){
      CurrencyTable.setCredits(owner, acc.credits - amount);
      CurrencyTable.setDebit(owner, 0);
    }
    else {
      if( (acc.credits + acc.tokens) < amount) revert InsufficientFunds();
      CurrencyTable.setCredits(owner, 0);
      CurrencyTable.setTokens(owner, acc.tokens - (amount - acc.credits));
      CurrencyTable.setDebit(owner, CurrencyTable.getDebit(owner) - amount);
    }

    notify(OperationEnum.CURRENCY_PAYMENT, abi.encode(owner, amount));
  }
}
