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

contract LedgerTuningSystemTest is MudTest {
  function test_setBaseDebit() public {
    // Set Time To Unstake
    uint256 baseDebit = LedgerTuning.getBaseDebit();
    assertTrue(0 != baseDebit);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetBaseDebit(baseDebit + 1);
    assertTrue(baseDebit + 1 == LedgerTuning.getBaseDebit());

    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetBaseDebit(11e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetBaseDebit(2_000_000e18);

    // Up the Max Debit to trigger max stake check
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxDebit(3_000_000e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetBaseDebit(2_000_000e18);
  }

  function test_setMaxDebit() public {
    // Set Time To Unstake
    uint256 maxDebit = LedgerTuning.getMaxDebit();
    assertTrue(0 != maxDebit);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxDebit(maxDebit + 1e18);
    assertTrue(maxDebit + 1e18 == LedgerTuning.getMaxDebit());

    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxDebit(11e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxDebit(1);
  }

  function test_setMaxStake() public {
    // Set Time To Unstake
    uint256 maxStake = LedgerTuning.getMaxStake();
    assertTrue(0 != maxStake);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxStake(maxStake + 1e18);
    assertTrue(maxStake + 1e18 == LedgerTuning.getMaxStake());

    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxStake(11e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxStake(1);
  }

  function test_setMaxUnstake() public {
    // Set Time To Unstake
    assertTrue(1e18 != LedgerTuning.getMaxUnstake());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxUnstake(1e18);
    assertTrue(1e18 == LedgerTuning.getMaxUnstake());

    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxUnstake(11e18);
  }

  function test_setTimeToUnstake() public {
    // Set Time To Unstake
    assertTrue(10 seconds != LedgerTuning.getTimeToUnstake());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetTimeToUnstake(10 seconds);
    assertTrue(10 seconds == LedgerTuning.getTimeToUnstake());

    vm.prank(GameConfig.getGm());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerTuningSetTimeToUnstake(11 seconds);
  }
}
