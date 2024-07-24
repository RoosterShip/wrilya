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

// Required For Testing MUD
import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MudTest} from "@latticexyz/world/test/MudTest.t.sol";

// Wrilya Table imports
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {Command} from "../src/codegen/common.sol";
import {GameConfig, Commands} from "../src/codegen/index.sol";
import "../src/offchain.sol";
import "../src/errors.sol";

contract GameSystemTest is MudTest {
  //---------------------------------------------------------------------------
  // Transfer GM Tests
  //---------------------------------------------------------------------------

  function test_transferGM() public {
    address aliceAddress = makeAddr("Alice");

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferGM(aliceAddress);

    assertEq(aliceAddress, GameConfig.getGm());
  }

  function test_transferGMToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferGM(address(0));
  }

  function test_transferGMFromNonGM() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferGM(makeAddr("Alice"));
  }

  //---------------------------------------------------------------------------
  // Transfer Governor Tests
  //---------------------------------------------------------------------------

  function test_transferGovernor() public {
    address aliceAddress = makeAddr("Alice");
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferGovernor(aliceAddress);

    assertEq(aliceAddress, GameConfig.getGovernor());
  }

  function test_transferGovernorToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferGovernor(address(0));
  }

  function test_transferGovernorFromNonGovernor() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferGovernor(makeAddr("Alice"));
  }

  //---------------------------------------------------------------------------
  // Transfer Payee Tests
  //---------------------------------------------------------------------------

  function test_transferPayeeProxy() public {
    address proxy = GameConfig.getPayee();
    address newProxy = makeAddr("Payee");
    assertTrue(proxy != newProxy);
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferPayee(newProxy);
    assertTrue(GameConfig.getPayee() == newProxy);
  }

  function test_transferPayeeToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferPayee(address(0));
  }

  function test_transferPayeeFromNonGovernor() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferPayee(makeAddr("Payee"));
  }

  //---------------------------------------------------------------------------
  // Transfer Currency Proxy Tests
  //---------------------------------------------------------------------------

  function test_transferCurrencyProxy() public {
    address proxy = GameConfig.getCurrencyProxy();
    address newProxy = makeAddr("CurrencyProxy");
    assertTrue(proxy != newProxy);
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferCurrencyProxy(newProxy);
    assertTrue(GameConfig.getCurrencyProxy() == newProxy);
  }

  function test_transferCurrencyProxyToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferCurrencyProxy(address(0));
  }

  function test_transferCurrencyProxyFromNonGovernor() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferCurrencyProxy(
      makeAddr("CurrencyProxy")
    );
  }

  //---------------------------------------------------------------------------
  // Transfer Item Proxy Tests
  //---------------------------------------------------------------------------

  function test_transferItemProxy() public {
    address proxy = GameConfig.getCurrencyProxy();
    address newProxy = makeAddr("ItemProxy");
    assertTrue(proxy != newProxy);
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferItemProxy(newProxy);
    assertTrue(GameConfig.getItemProxy() == newProxy);
  }

  function test_transferItemProxyToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferItemProxy(address(0));
  }

  function test_transferCurrencyItemFromNonGovernor() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferItemProxy(makeAddr("ItemProxy"));
  }

  //---------------------------------------------------------------------------
  // Transfer Entity Proxy Tests
  //---------------------------------------------------------------------------

  function test_transferEntityProxy() public {
    address proxy = GameConfig.getEntityProxy();
    address newProxy = makeAddr("EntityProxy");
    assertTrue(proxy != newProxy);
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__transferEntityProxy(newProxy);
    assertTrue(GameConfig.getEntityProxy() == newProxy);
  }

  function test_transferEntityProxyToZero() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__transferEntityProxy(address(0));
  }

  function test_transferEntityItemFromNonGovernor() public {
    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__transferItemProxy(makeAddr("EntityProxy"));
  }

  //---------------------------------------------------------------------------
  // Pause Tests
  //---------------------------------------------------------------------------

  function test_PauseWhenActive() public {
    assertEq(GameConfig.getActive(), true);
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__pause();
    assertEq(GameConfig.getActive(), false);
  }

  function test_PauseWhenNotGM() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__pause();
  }

  function test_PauseWhenPaused() public {
    assertEq(GameConfig.getActive(), true);
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__pause();
    // Should fail here
    vm.prank(GameConfig.getGm());
    vm.expectRevert(GameActiveState.selector);
    IWorld(worldAddress).wrilya__pause();
  }

  //---------------------------------------------------------------------------
  // Run Tests
  //---------------------------------------------------------------------------

  function test_RunWhenPaused() public {
    // Setup
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__pause();
    assertEq(GameConfig.getActive(), false);

    // Now let's resume it
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__run();
    assertEq(GameConfig.getActive(), true);
  }

  function test_RunWhenNotGM() public {
    assertEq(GameConfig.getActive(), true);
    // Should work
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__pause();

    // Should fail
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__run();
  }

  function test_RunWhenRunning() public {
    assertEq(GameConfig.getActive(), true);
    // Should fail here
    vm.prank(GameConfig.getGm());
    vm.expectRevert(GameActiveState.selector);
    IWorld(worldAddress).wrilya__run();
  }
}
