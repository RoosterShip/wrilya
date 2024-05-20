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
import { notify, requireAdmin, requireGM, requireRunning, requireHalted } from "../utils.sol";
import { GameConfigTable  } from "../codegen/index.sol";
import { OperationEnum  } from "../codegen/common.sol";

// ----------------------------------------------------------------------------
/// @title GameSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract GameSystem is System {

  /**
   * Call to put the game in a paused state.  Many operations will require
   * that the game be running so doing this will cause those commands to
   * revert.
   */
  function pause() public {
    requireGM(_msgSender());
    requireHalted();
    GameConfigTable.setActive(false);
    notify(OperationEnum.GAME_PAUSE, ""); 
  }

  /**
   * Unpauase the game and allow for on chain operations to begin again.
   */
  function unpause() public {
    requireGM(_msgSender());
    requireRunning();
    GameConfigTable.setActive(true);
    notify(OperationEnum.GAME_UNPAUSE, ""); 
  }

  /**
   * Set the Address for the GM Account.
   * 
   * Please see documentation for more information about the GM Account
   * 
   * @param newGM address that is now the GM
   */
  function setGM(address newGM) public {
    requireAdmin(_msgSender());
    GameConfigTable.setGm(newGM);
    notify(OperationEnum.GAME_SET_GM, ""); 
  }

  /**
   * Set the Address for the admin account.
   * 
   * Please see documentation for more information about the admin account
   * 
   * @param newAdmin address that is now the admin
   */
  function setAdmin(address newAdmin) public {
    requireAdmin(_msgSender());
    GameConfigTable.setAdmin(newAdmin);
    notify(OperationEnum.GAME_SET_ADMIN, ""); 
  }

  /**
   * Set the address of the currency ERC-20 proxy contract.
   * @param proxy address to accept ERC-20 ops from
   */
  function setCurrencyProxy(address proxy) public {
    requireAdmin(_msgSender());
    GameConfigTable.setCurrencyProxy(proxy);
    notify(OperationEnum.GAME_SET_CURRENCY_PROXY, ""); 
  }

  /**
   * Set the address for the item (ERC-1155) proxy contract
   * @param proxy address to accept ERC-1155 ops from
   */ 
  function setItemProxy(address proxy) public {
    requireAdmin(_msgSender());
    GameConfigTable.setItemProxy(proxy);
    notify(OperationEnum.GAME_SET_ITEM_PROXY, ""); 
  }

  /**
   * Set the address for the entity (ERC-721) proxy contract 
   * @param proxy address to accept ERC-721 ops from
   */
  function setEntityProxy(address proxy) public {
    requireAdmin(_msgSender());
    GameConfigTable.setEntityProxy(proxy);
    notify(OperationEnum.GAME_SET_ENTITY_PROXY, ""); 
  }

}
