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
  GameActiveState,
  InvalidArgument,
  InvalidState,
  Unauthorized
} from "../errors.sol";
import {GameConfig} from "../codegen/index.sol";
import {System} from "@latticexyz/world/src/System.sol";
import {World} from "@latticexyz/world/src/World.sol";
import {NamespaceOwner} from "@latticexyz/world/src/codegen/index.sol";
import {ROOT_NAMESPACE_ID} from "@latticexyz/world/src/constants.sol";

// ----------------------------------------------------------------------------
/// @title GameSystem
/// @author Chris Jimison
/// @notice MUD.dev based smart for Game Voidsmen.
contract GameSystem is System {
  /**
   * @dev a "Constructor" like interface setup the game config values.
   *
   * Requirements:
   *
   * - Has not been called before.
   * - Only the deployer of the contracts can call this
   * - The gm_, payee_ and gov_ contracts are not zero
   *
   * @param gm_ address for the game master
   * @param payee_ address for the where payments goto in the game
   * @param gov_ address for the governor contract
   * @param curProxy_ address for the currency proxy contract
   * @param itemProxy_  address for the item proxy contract
   * @param entityProxy_  address for the entity proxy contract
   */
  function initialize(
    address gm_,
    address payee_,
    address gov_,
    address curProxy_,
    address itemProxy_,
    address entityProxy_
  ) public {
    address zero = address(0);

    //---------------------------------
    // Verification Block
    //---------------------------------

    // Arguments Check
    bool argCheck = zero != gm_ && zero != payee_ && zero != gov_;
    require(argCheck, InvalidArgument());

    // Caller Check
    require(
      _msgSender() == NamespaceOwner.getOwner(ROOT_NAMESPACE_ID), Unauthorized()
    );

    // State Check
    bool stateCheck = false == GameConfig.getActive()
      && zero == GameConfig.getGm() && zero == GameConfig.getGovernor()
      && zero == GameConfig.getPayee();
    require(stateCheck, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------

    GameConfig.set(
      false, gov_, gm_, payee_, curProxy_, itemProxy_, entityProxy_
    );
  }

  /**
   * @dev Transfer the ownership of a GM to another address.
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the GM.
   * - New address can not be zero
   *
   * @param gm_ address to transfer game master to
   */
  function transferGM(address gm_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != gm_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setGm(gm_);
  }

  /**
   * @dev Transfer the ownership of a Governor to another address.
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the Governor.
   * - New address can not be zero
   *
   * @param gov_ address to transfer governership to
   */
  function transferGovernor(address gov_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != gov_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setGovernor(gov_);
  }

  /**
   * @dev Transfer the ownership of the Payee to another address.
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the payee.
   * - New address can not be zero
   *
   * @param payee_ address to transfer payee to
   */
  function transferPayee(address payee_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != payee_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setPayee(payee_);
  }

  /**
   * @dev Change the address of the currency proxy contract
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the payee.
   * - New address can not be zero
   *
   * @param proxy_ address of the new contract
   */
  function transferCurrencyProxy(address proxy_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != proxy_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setCurrencyProxy(proxy_);
  }

  /**
   * @dev Change the address of the item proxy contract
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the payee.
   * - New address can not be zero
   *
   * @param proxy_ address of the new contract
   */
  function transferItemProxy(address proxy_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != proxy_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setItemProxy(proxy_);
  }

  /**
   * @dev Change the address of the entity proxy contract
   *
   * Requirements:
   *
   * - Only the Governor can transfer ownership of the payee.
   * - New address can not be zero
   *
   * @param proxy_ address of the new contract
   */
  function transferEntityProxy(address proxy_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(address(0) != proxy_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setEntityProxy(proxy_);
  }

  /**
   * @dev Pause the contracts environment.
   *
   * NOTE: Not all functions will become disabled when pasued.
   *       Only gameplay related functions will fail the check.
   *
   * Requirements:
   *
   * - Only the GM can pause the game
   * - The game must be "running"
   */
  function pause() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGm(), Unauthorized());
    require(GameConfig.getActive(), GameActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setActive(false);
  }

  /**
   * @dev Set the game state to active and allow gameplay
   * based transaction to go through.
   *
   * Requirements:
   *
   * - Only the GM can pause the game
   * - The game must be "paused"
   */
  function run() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGm(), Unauthorized());
    require(!GameConfig.getActive(), GameActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    GameConfig.setActive(true);
  }
}
