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
import "../src/utils.sol";
import {BanTuning, GameConfig} from "../src/codegen/index.sol";

/**
 * @title EntitySystemTest
 * @author Chris Jimison
 * @notice Collection of tests for the Entity System API
 */
contract EntitySystemTest is MudTest, GasReporter {
  /**
   * @dev Set the times for the temp ban times
   */
  function test_standard_usage() public {
    address gmAddress = GameConfig.getGm();
    address entityProxyAddress = GameConfig.getEntityProxy();
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");
    bytes16 offChainRef = 0x11111111111111111111111111111111;

    // Mint a Voidsman for testing
    assertEq(
      0, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(aliceAddress))
    );

    vm.prank(gmAddress);
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef, toBytes32(aliceAddress)
    );

    assertEq(
      1, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(aliceAddress))
    );

    assertEq(
      toBytes32(aliceAddress),
      IWorld(worldAddress).wrilya__entityOwnerOf(entityId)
    );

    // EntityTransfer 2 Test
    vm.prank(entityProxyAddress);
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), toBytes32(bobAddress), entityId
    );
    assertEq(
      0, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(aliceAddress))
    );

    assertEq(
      1, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(bobAddress))
    );

    assertEq(
      toBytes32(bobAddress),
      IWorld(worldAddress).wrilya__entityOwnerOf(entityId)
    );

    // EntityTransfer 2 Test
    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), entityId
    );
    assertEq(
      0, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(bobAddress))
    );

    assertEq(
      1, IWorld(worldAddress).wrilya__entityBalanceOf(toBytes32(aliceAddress))
    );

    assertEq(
      toBytes32(aliceAddress),
      IWorld(worldAddress).wrilya__entityOwnerOf(entityId)
    );
  }

  /**
   * @dev Test to verify failure conditions
   */
  function test_entityTransfer_failures() public {
    address gmAddress = GameConfig.getGm();
    address entityProxyAddress = GameConfig.getEntityProxy();
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");
    address tedAddress = makeAddr("Ted");
    bytes16 offChainRef = 0x11111111111111111111111111111111;
    bytes32 futureEntity =
      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    // Mint a Voidsman for testing
    vm.prank(gmAddress);
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef, toBytes32(aliceAddress)
    );

    // Transfer 3 - Failed Attempt: Non Proxy transfer call
    vm.prank(gmAddress);
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), toBytes32(bobAddress), entityId
    );

    // Transfer 3 - Failed Attempt: Non Owner
    vm.prank(entityProxyAddress);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(tedAddress), toBytes32(bobAddress), entityId
    );

    // Transfer 3 - Failed Attempt: Zero Address
    vm.prank(entityProxyAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), bytes32(0), entityId
    );

    // Transfer 3 - Hack where we could set a non-minted entity ID to an address
    vm.prank(entityProxyAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__entityTransfer(
      bytes32(0), toBytes32(aliceAddress), futureEntity
    );

    // Transfer 2 - Failed Attempt: Non Owner
    vm.prank(tedAddress);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__entityTransfer(toBytes32(bobAddress), entityId);

    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__entityTransfer(bytes32(0), entityId);
  }

  /**
   * @dev Test to track the gas costs of usage
   */
  function test_entitySystemGasReport() public {
    address gmAddress = GameConfig.getGm();
    address entityProxyAddress = GameConfig.getEntityProxy();
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");
    bytes16 offChainRef = 0x11111111111111111111111111111111;

    vm.prank(gmAddress);
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef, toBytes32(aliceAddress)
    );

    // EntityTransfer 2 Test
    vm.startPrank(entityProxyAddress);
    startGasReport("wrilya__entityTransfer/3");
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), toBytes32(bobAddress), entityId
    );
    endGasReport();
    vm.stopPrank();

    // EntityTransfer 2 Test
    vm.startPrank(bobAddress);
    startGasReport("wrilya__entityTransfer/2");
    IWorld(worldAddress).wrilya__entityTransfer(
      toBytes32(aliceAddress), entityId
    );
    endGasReport();
    vm.stopPrank();
  }
}
