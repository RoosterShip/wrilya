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
import { EntityCounter, Crew, Persona, OwnedBy } from "../codegen/index.sol";
import { toBytes32 } from "../toBytes32.sol";
import { Unauthorized } from "../errors.sol";
import { Race } from "../codegen/common.sol";

// ----------------------------------------------------------------------------
/// @title CrewSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Crew.
contract CrewSystem is System {

  /// Mint a new Crew Member.  To do so you will need to supply the crew member
  /// name and race.  The value of a crew member is based on how high up they
  /// have been leveled up, not based on some rarity or random number, etc.
  /// @param name of the new crew member
  function recruitCrew(string calldata name, Race race) public {
    bytes32 owner = toBytes32(_msgSender());
    uint256 entityValue = EntityCounter.get();
    EntityCounter.set(entityValue + 1);
    bytes32 entityId = toBytes32(entityValue);
    OwnedBy.set(entityId, owner);
    Crew.set(entityId, true);
    Persona.set(entityId, race, 0, 0, 0, 0, 0, 0, 0, 0, 0, name);
  }
}
