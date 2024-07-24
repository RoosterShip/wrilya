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

// -----------------------------------------------------------------------------
// Imports
// -----------------------------------------------------------------------------

import {System} from "@latticexyz/world/src/System.sol";
import {EntityBalance, EntityInfo, GameConfig} from "../codegen/index.sol";
import {InvalidArgument, InvalidState, Unauthorized} from "../errors.sol";
import {toBytes32} from "../utils.sol";

// -----------------------------------------------------------------------------
/// @title EntitySystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Entity System.
contract EntitySystem is System {
  /**
   * @dev get the balance count of all the entities owned by a player.
   *
   * NOTE:
   *
   * This function was created for the proxies.  If you need the
   * entity balance it is better to get it from REC or the Indexer.
   *
   * @param owner_ to get the entity balance
   * @return count_ of entities owned by the given address
   */
  function entityBalanceOf(bytes32 owner_) public view returns (uint256) {
    //---------------------------------
    // Logic Block
    //---------------------------------
    return EntityBalance.get(owner_);
  }

  /**
   * @dev Get the owner of an entity
   *
   * NOTE:
   *
   * This function was created for the proxies.  If you need the
   * entity balance it is better to get it from REC or the Indexer.
   *
   * @param entityId_ to find the owner for
   * @return owner_ who owns the entity
   */
  function entityOwnerOf(bytes32 entityId_) public view returns (bytes32) {
    //---------------------------------
    // Logic Block
    //---------------------------------
    return EntityInfo.getOwner(entityId_);
  }

  /**
   * @dev Transfer an entity
   *
   * Requirements:
   *
   * - Only the Entity Proxy and call this.
   * - The `from_` field must be the current owner of `entityId_`
   * - The `to_` field can not be 0
   * - The `from_` field can not be 0
   *
   * @param from_ account that owns the entity now
   * @param to_ account that will receive the entity now
   * @param entityId_ to transfer ownership
   */
  function entityTransfer(bytes32 from_, bytes32 to_, bytes32 entityId_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getEntityProxy(), Unauthorized());
    require(EntityInfo.getOwner(entityId_) == from_, InvalidState());
    require((bytes32(0) != from_) && (bytes32(0) != to_), InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    EntityBalance.set(from_, EntityBalance.get(from_) - 1);
    EntityBalance.set(to_, EntityBalance.get(to_) + 1);
    EntityInfo.setOwner(entityId_, to_);
  }

  /**
   * @dev Transfer an entity
   *
   * Requirements:
   *
   * - The caller field must be the current owner of `entityId_`
   * - The `to_` field can not be 0
   *
   * @param to_ account that will receive the entity now
   * @param entityId_ to transfer ownership
   */
  function entityTransfer(bytes32 to_, bytes32 entityId_) public {
    bytes32 from = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(EntityInfo.getOwner(entityId_) == from, InvalidState());
    require((bytes32(0) != from) && (bytes32(0) != to_), InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    EntityBalance.set(from, EntityBalance.get(from) - 1);
    EntityBalance.set(to_, EntityBalance.get(to_) + 1);
    EntityInfo.setOwner(entityId_, to_);
  }
}
