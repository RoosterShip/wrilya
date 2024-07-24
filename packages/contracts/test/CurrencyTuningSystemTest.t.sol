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
import {GasReporter} from "@latticexyz/gas-report/src/GasReporter.sol";

// Wrilya Table imports
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {Command} from "../src/codegen/common.sol";
import "../src/codegen/index.sol";
import "../src/errors.sol";

contract CurrencyTuningSystemTest is MudTest {
  /**
   * @dev Checks to ensure that the banned logic is tracking
   */
  function test_currentTuningSet_failures() public {
    // The system already called this once so let's make sure we can't call it
    // again

    vm.prank(makeAddr("Alice"));
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyTuningSet(100e18, 0.1e18, 0.2e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__currencyTuningSet(0, 0.1e18, 0.2e18);
  }

  function test_currentTuningSetXchgFeeBuy() public {
    assertTrue(0.1e18 != CurrencyTuning.getXchgFeeBuy());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyTuningSetXchgFeeBuy(0.1e18);
    assertTrue(0.1e18 == CurrencyTuning.getXchgFeeBuy());

    vm.prank(makeAddr("Alice"));
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyTuningSetXchgFeeBuy(22e18);
  }

  function test_currentTuningSetXchgFeeSell() public {
    assertTrue(0.1e18 != CurrencyTuning.getXchgFeeSell());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyTuningSetXchgFeeSell(0.1e18);
    assertTrue(0.1e18 == CurrencyTuning.getXchgFeeSell());

    vm.prank(makeAddr("Alice"));
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyTuningSetXchgFeeSell(22e18);
  }

  function test_currentTuningSetMaxSupply() public {
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__currencyTuningSetMaxSupply(1e18);

    vm.prank(makeAddr("Alice"));
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyTuningSetXchgFeeSell(22e18);
  }
}
