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
import {GameConfig} from "../src/codegen/index.sol";

/**
 * @title BannedSystemTest
 * @author Chris Jimison
 * @notice Collection of tests for the Banned System API
 */
contract BannedSystemTest is MudTest, GasReporter {
  /**
   * @dev Positive Testing for issuing a temp ban on a player
   */
  function test_bannedIssueTemp() public {
    address gmAddress = GameConfig.getGm();
    address bobAddr = makeAddr("Bob");

    // Verify not banned
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban in effect test
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban expired test
    vm.warp(block.timestamp + 8 days);
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));
  }

  /**
   * @dev Requirement failure for non-GM account attempting ban
   */
  function test_bannedIssueTemp_nonGM() public {
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    vm.expectRevert(Unauthorized.selector);
    vm.startPrank(aliceAddr);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    vm.stopPrank();
  }

  /**
   * @dev Requirement failure when issuing a second temp ban
   */
  function test_bannedIssueTemp_existingBan() public {
    address gmAddress = GameConfig.getGm();
    address bobAddr = makeAddr("Bob");

    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Double Ban
    vm.expectRevert(BannedAddress.selector);
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
  }

  /**
   * @dev Positive Testing for issuing a temp ban on a player
   */
  function test_bannedReleaseTemp() public {
    address gmAddress = GameConfig.getGm();
    address bobAddr = makeAddr("Bob");

    // Verify not banned
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban in effect test
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Release Ban
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedReleaseTemp(bobAddr);
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Reban
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));
  }

  /**
   * @dev Requirement failure for non-GM account attempting release
   */
  function test_bannedReleaseTemp_nonGM() public {
    address gmAddress = GameConfig.getGm();
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    // Verify not banned
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban Account
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);

    // Ban Fail
    vm.expectRevert(Unauthorized.selector);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__bannedReleaseTemp(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));
  }

  /**
   * @dev Positive Testing for issuing a perm ban on a player
   */
  function test_bannedIssuePerm() public {
    address govAddress = GameConfig.getGovernor();
    address bobAddr = makeAddr("Bob");

    // Verify not banned
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban in effect test
    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Release the ban
    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedReleasePerm(bobAddr);
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));
  }

  /**
   * @dev Requirements Testing for issuing a perm ban on a player
   */
  function test_bannedIssuePerm_nonGovernor() public {
    address govAddress = GameConfig.getGovernor();
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    // Verify not banned
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Failed ban attempt
    vm.expectRevert(Unauthorized.selector);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddr);
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));

    // Ban in effect test
    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Failed ban attempt
    vm.expectRevert(Unauthorized.selector);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__bannedReleasePerm(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    // Release the ban
    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedReleasePerm(bobAddr);
    assertTrue(false == IWorld(worldAddress).wrilya__banned(bobAddr));
  }

  /**
   * @dev Some mix case testing with perm and temp bans
   */
  function test_bannedMixed() public {
    address gmAddress = GameConfig.getGm();
    address govAddress = GameConfig.getGovernor();
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    // Perm ban then temp ban
    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(bobAddr));

    vm.prank(gmAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);

    // Temp ban then perm ban
    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(aliceAddr);

    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(aliceAddr));

    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedReleaseTemp(aliceAddr);
    assertTrue(IWorld(worldAddress).wrilya__banned(aliceAddr));
  }

  /**
   * @dev A gas report of the successful execution of the functions
   */
  function test_bannedGasReport() public {
    address gmAddress = GameConfig.getGm();
    address govAddress = GameConfig.getGovernor();
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    // Start Banned Temp Calls
    vm.startPrank(gmAddress);

    startGasReport("wrilya__bannedIssueTemp");
    IWorld(worldAddress).wrilya__bannedIssueTemp(bobAddr);
    endGasReport();

    startGasReport("wrilya__bannedReleaseTemp");
    IWorld(worldAddress).wrilya__bannedReleaseTemp(bobAddr);
    endGasReport();

    vm.stopPrank();

    // Start Banned Perm Calls

    vm.startPrank(govAddress);

    startGasReport("wrilya__bannedIssuePerm");
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    endGasReport();

    startGasReport("wrilya__bannedReleasePerm");
    IWorld(worldAddress).wrilya__bannedReleasePerm(aliceAddr);
    endGasReport();

    vm.stopPrank();
  }
}
