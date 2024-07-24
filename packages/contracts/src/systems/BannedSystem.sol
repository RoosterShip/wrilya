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
import {BannedAddress, Unauthorized} from "../errors.sol";
import {isBanned} from "../checks.sol";
import {BanTuning, BanTemp, BanPerm, GameConfig} from "../codegen/index.sol";

// ----------------------------------------------------------------------------
/**
 * @title BannedSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract for banning accounts
 */
contract BannedSystem is System {
  /**
   * @dev Check to see if an account is banned.
   * @param account_ to lookup banned flag
   * @return status banned value
   */
  function banned(address account_) public view returns (bool status) {
    //---------------------------------
    // Logic Block
    //---------------------------------
    status = isBanned(account_);
  }

  /**
   * @dev Issue a temporary ban for this account.  Will expire based on tuning
   * value set by the community.
   *
   * Requirements:
   *
   * - Only the GM can issue this request
   * - Account must not already be banned.
   *
   * TODO:
   * - Fix logic flaw where GM can keep reissuing ban thus creating a perm ban
   *
   * @param account_ to temporarly banned
   */
  function bannedIssueTemp(address account_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGm(), Unauthorized());
    require(!isBanned(account_), BannedAddress());

    //---------------------------------
    // Logic Block
    //---------------------------------
    uint256 time = block.timestamp + BanTuning.getTempTime();
    BanTemp.set(account_, time);
  }

  /**
   * @dev Remove a temporary ban issued for an account regardless if set or not
   *
   * Requirements:
   *
   * - Only the GM can release a temporary ban
   *
   * @param account_ to be released from the ban
   */
  function bannedReleaseTemp(address account_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGm(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    BanTemp.deleteRecord(account_);
  }

  /**
   * @dev set the account to be perminately banned
   *
   * Requirements:
   *
   * - Only the governor can issue ban
   *
   * @param account_ to assign as banned
   */
  function bannedIssuePerm(address account_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    BanPerm.set(account_, true);
  }

  /**
   * @dev release the account from a perminately banned
   *
   * Requirements:
   *
   * - Only the governor can issue ban
   *
   * @param account_ to be released from ban
   */
  function bannedReleasePerm(address account_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    BanPerm.deleteRecord(account_);
  }
}
