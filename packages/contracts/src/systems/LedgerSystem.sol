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

// ----------------------------------------------------------------------------
/// @title LedgerSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract LedgerSystem is System {
  /**
   * @dev Looks up the balance for a given id.  This can be either an account or
   * a entity id
   *
   * @param id_ to lookup the balance for
   */
  function ledgerTokenBalanceOf(bytes32 id_) public view returns (uint256) {
    return LedgerInfo.getTokens(id_);
  }

  /**
   * @dev Transfer Tokens from the caller to the receiver.
   *
   * Requirements:
   *
   * - Receiver is not address 0
   * - Receiver is not on the banned list
   * - Caller is not on the banned list
   * - Caller has enough tokens
   *
   * @param receiver_ to have tokens tranfered into their account
   * @param amount_ of tokens to transfer.
   */
  function ledgerTokenTransfer(address receiver_, uint256 amount_) public {
    address caller = _msgSender();
    bytes32 account = toBytes32(caller);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(receiver_ != ZERO_ADDRESS, InvalidArgument());
    require(!isBanned(caller), BannedAddress());
    require(!isBanned(receiver_), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(account, toBytes32(receiver_), amount_);
  }

  /**
   * @dev Transfer Tokens from the caller to the receiver entity.
   *
   * Requirements:
   *
   * - Receiver is valid system entity
   * - Receiver entity is owned by someone
   * - Caller is not on the banned list
   * - Caller has enough tokens
   *
   * @param receiver_ entityId to have tokens tranfered into their account
   * @param amount_ of tokens to transfer.
   */
  function ledgerTokenTransfer(bytes32 receiver_, uint256 amount_) public {
    address caller = _msgSender();
    bytes32 account = toBytes32(caller);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(isSystemEntity(receiver_), InvalidArgument());
    require(EntityInfo.getOwner(receiver_) != ZERO_BYTES32, InvalidOwner());
    require(!isBanned(caller), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(account, receiver_, amount_);
  }

  /**
   * @dev Transfer the value from a system entity to another account.
   *
   * Requirements:
   *
   * - from can not be value zero
   * - from has to be a system entity
   * - from owner must be the caller
   * - receiver can not be address zero
   * - If the receiver is a system entity it must have a valid owner
   * - If the reciever is an account it can not be banned
   *
   * @param from_ entity to transfer currency from it
   * @param receiver_ account or entity the value will be transfered to
   * @param amount_ the amount to transfer
   */
  function ledgerTokenTransfer(
    bytes32 from_,
    bytes32 receiver_,
    uint256 amount_
  ) public {
    address caller = _msgSender();

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(!isBanned(caller), BannedAddress());
    require(isSystemEntity(from_), InvalidArgument());
    require(EntityInfo.getOwner(from_) == toBytes32(caller), InvalidOwner());

    if (isSystemEntity(receiver_)) {
      // We don't support ownership chaining/deep linking when it comes to token
      // transfers
      bytes32 rOwner = EntityInfo.getOwner(receiver_);
      require(isAccountEntity(rOwner), InvalidOwner());
      require(!isBanned(toAddress(rOwner)), BannedAddress());
    } else if (isAccountEntity(receiver_)) {
      require(!isBanned(toAddress(receiver_)), BannedAddress());
    } else {
      revert InvalidArgument();
    }

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(from_, receiver_, amount_);
  }

  /**
   * @dev Callable from the currency proxy to transfer funds
   *
   * Requirements:
   *
   * - Sender must be the currency proxy
   * - from is not address zero
   * - from is not banned
   * - receiver is not address zero
   * - receiver is not banned
   * - from must have enough funds
   *
   *
   * @param from_ account to pull funds from
   * @param receiver_ account to put funds into
   * @param amount_ of funds to transfer
   */
  function ledgerTokenTransfer(
    address from_,
    address receiver_,
    uint256 amount_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getCurrencyProxy(), InvalidCaller());
    require(from_ != ZERO_ADDRESS, InvalidArgument());
    require(!isBanned(from_), BannedAddress());
    require(receiver_ != ZERO_ADDRESS, InvalidArgument());
    require(!isBanned(receiver_), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(toBytes32(from_), toBytes32(receiver_), amount_);
  }

  /**
   * @dev Move the amount of tokens into your "staked" pool
   *
   * Requirments:
   *
   * - Caller is not banned from the system
   * - Caller has equal to or more than the amount of tokens
   * - When complete caller should not have more then max stake value
   *
   * @param amount_ of tokens to stake from your ledger
   */
  function ledgerStake(uint256 amount_) public {
    address caller = _msgSender();
    bytes32 account = toBytes32(caller);
    uint256 tokens = LedgerInfo.getTokens(account);
    uint256 staked = LedgerInfo.getStaked(account);
    uint256 sum = amount_ + staked;

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(!isBanned(caller), BannedAddress());
    require(tokens >= amount_, InsufficientFunds());
    require(LedgerTuning.getMaxStake() >= sum, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    LedgerInfo.setTokens(account, tokens - amount_);
    LedgerInfo.setStaked(account, sum);
  }

  /**
   * @dev Request to unstake an amount.
   *
   * Requirements:
   *
   * - Caller is not banned from the system
   * - Caller has equal to or more than the amount of tokens staked
   * - Caller is not currently unstaking tokens
   * - Amount is less then the max amount which can be unstaked
   * - Amount is greater then zero
   *
   * @param amount_ to unstake
   */
  function ledgerUnstake(uint256 amount_) public {
    address caller = _msgSender();
    bytes32 account = toBytes32(caller);
    uint256 staked = LedgerInfo.getStaked(account);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(!isBanned(caller), BannedAddress());
    require(staked >= amount_, InsufficientFunds());
    require(
      (0 == LedgerInfo.getUnstaked(account))
        && (0 == LedgerInfo.getUts(account)),
      InvalidState()
    );
    require(amount_ <= LedgerTuning.getMaxUnstake(), OutOfBounds());
    require(amount_ > 0, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    LedgerInfo.setStaked(account, staked - amount_);
    LedgerInfo.setUnstaked(account, amount_);
    LedgerInfo.setUts(
      account, block.timestamp + LedgerTuning.getTimeToUnstake()
    );
  }

  /**
   * @dev Claim any unstaked tokens that have gone past the unstaking time
   *
   * Requirements:
   *
   * - Caller is not banned from the system
   * - Caller has some amount of tokens to unstake
   * - The timestamp of the uinstake is not equal to 0
   * - The timestamp of the unstake is less then the current time
   *
   */
  function ledgerClaim() public {
    address caller = _msgSender();
    bytes32 account = toBytes32(caller);
    uint256 unstaked = LedgerInfo.getUnstaked(account);
    uint256 uts = LedgerInfo.getUts(account);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(!isBanned(caller), BannedAddress());
    require(0 != unstaked && 0 != uts, InvalidState());
    require(block.timestamp >= uts, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    LedgerInfo.setTokens(account, LedgerInfo.getTokens(account) + unstaked);
    LedgerInfo.setUnstaked(account, 0);
    LedgerInfo.setUts(account, 0);
  }

  /**
   * @dev Make a payment to the system.  This will reduce the callers
   * debit owned.  If the amount is greater then the debit owed, only
   * the debit amount is taken, NOT the full amount.
   *
   * NOTE: will use all credits BEFORE tokens.
   *
   * Requirements:
   *
   * - Caller is not banned from the system
   * - Caller has enough funds (credits + tokens) to pay off the debit
   *
   * @param amount_ of debit to pay off
   */
  function ledgerPayment(uint256 amount_) public {
    address caller = _msgSender();

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(!isBanned(caller), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.payment(toBytes32(caller), amount_);
  }

  /**
   * @dev Send some credits to a receiver
   *
   * Requirements:
   *
   * - Only GM can credit accounts
   * - receiver is not address 0
   * - reciever is not on the banned account list
   *
   * @param receiver_ of the credits
   * @param amount_ of credis to receive
   */
  function ledgerCredit(address receiver_, uint256 amount_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGm() == _msgSender(), Unauthorized());
    require(address(0) != receiver_, InvalidArgument());
    require(!isBanned(receiver_), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    bytes32 account = toBytes32(receiver_);
    LedgerInfo.setCredits(account, LedgerInfo.getCredits(account) + amount_);
  }

  /**
   * @dev Bill an account a given amount.  The bill will first fill up any
   * space left in the debit balance, then pull the remainder from credits
   * and if there is still more owned it will pull from tokens.
   *
   * Requirements:
   *
   * - Account has enough to pay the bill
   * - Only the GM can call this
   * - Recipient is not address 0
   * - Recipient is not banned
   *
   * @param recipient_ who must pay this bill
   * @param amount_ of the bill which much be paid off
   */
  function ledgerBill(address recipient_, uint256 amount_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGm() == _msgSender(), Unauthorized());
    require(address(0) != recipient_, InvalidArgument());
    require(!isBanned(recipient_), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.bill(toBytes32(recipient_), amount_);
  }
}
