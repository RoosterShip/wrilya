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
import {IWorld} from "../src/codegen/world/IWorld.sol";
import "../src/errors.sol";
import {BanTuning, GameConfig} from "../src/codegen/index.sol";

/**
 * @title BannedTuningSystemTest
 * @author Chris Jimison
 * @notice Collection of tests for the Banned Tuning System API
 */
contract BannedTuningSystemTest is MudTest, GasReporter {
  /**
   * @dev Set the times for the temp ban times
   */
  function test_basic() public {
    address govAddress = GameConfig.getGovernor();
    address aliceAddr = makeAddr("Alice");

    // Verify that the time is not 1 second
    assertTrue(1 seconds != BanTuning.getTempTime());

    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedTuningSet(1 seconds);
    assertEq(1 seconds, BanTuning.getTempTime());

    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedTuningSetTempTime(2 seconds);
    assertEq(2 seconds, BanTuning.getTempTime());

    vm.startPrank(aliceAddr);
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__bannedTuningSet(3 seconds);
    assertEq(2 seconds, BanTuning.getTempTime());

    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__bannedTuningSetTempTime(4 seconds);
    assertEq(2 seconds, BanTuning.getTempTime());
    vm.stopPrank();
  }
}
