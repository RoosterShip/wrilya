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
import "../src/utils.sol";

contract MarketSystemTest is MudTest {
  //----------------------------------------------------------------------------
  // Helper
  //----------------------------------------------------------------------------

  function mintAndTransfer(address addr_, uint256 amt_) private {
    deal(GameConfig.getGovernor(), 1.1 ether);

    vm.startPrank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(amt_);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(addr_, amt_);
    vm.stopPrank();
  }

  /**
   * @dev Create a List price lot
   */
  function test_marketListPrice() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    deal(aliceAddress, 1.1 ether);
    mintAndTransfer(aliceAddress, 50e18);

    address bobAddress = makeAddr("Bob");
    deal(bobAddress, 1.1 ether);
    mintAndTransfer(bobAddress, 50e18);

    // Mint an entity
    vm.prank(GameConfig.getGm());
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      0x11111111111111111111111111111111, toBytes32(aliceAddress)
    );

    // Create a list price entry
    vm.prank(aliceAddress);
    bytes32 aId =
      IWorld(worldAddress).wrilya__marketCreateListLot(entityId, 40e18);
    assertEq(
      50e18 - MPTuning.getListFee(),
      LedgerInfo.getTokens(toBytes32(aliceAddress))
    );

    // Have Bob Buy the assets
    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 40e18);
    assertTrue(EntityInfo.getOwner(entityId) == toBytes32(bobAddress));

    assertEq(10e18, LedgerInfo.getTokens(toBytes32(bobAddress)));
    assertEq(
      90e18 - MPTuning.getListFee() - percent(40e18, MPTuning.getListRake()),
      LedgerInfo.getTokens(toBytes32(aliceAddress))
    );
  }

  /**
   * @dev Create a Dutch Auction
   */
  function test_marketDutch() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    deal(aliceAddress, 1.1 ether);
    mintAndTransfer(aliceAddress, 50e18);

    address bobAddress = makeAddr("Bob");
    deal(bobAddress, 1.1 ether);
    mintAndTransfer(bobAddress, 50e18);

    // Mint an entity
    vm.prank(GameConfig.getGm());
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      0x11111111111111111111111111111111, toBytes32(aliceAddress)
    );

    // Create a list price entry
    vm.prank(aliceAddress);
    bytes32 aId = IWorld(worldAddress).wrilya__marketCreateDutchLot(
      entityId, 10 hours, 40e18, 20e18
    );

    assertEq(
      50e18 - MPTuning.getDutchFee(),
      LedgerInfo.getTokens(toBytes32(aliceAddress))
    );

    vm.warp(block.timestamp + 5 hours);

    // Have Bob Buy the assets
    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 30.001e18);
    assertTrue(EntityInfo.getOwner(entityId) == toBytes32(bobAddress));

    assertTrue(20e18 >= LedgerInfo.getTokens(toBytes32(bobAddress)));
    assertTrue(19.99e18 <= LedgerInfo.getTokens(toBytes32(bobAddress)));

    uint256 estTokens =
      80e18 - MPTuning.getDutchFee() - percent(30e18, MPTuning.getDutchRake());

    uint256 actualTokens = LedgerInfo.getTokens(toBytes32(aliceAddress));

    assertTrue((estTokens + 0.001e18) > actualTokens);
    assertTrue((estTokens - 0.001e18) < actualTokens);
  }

  /**
   * @dev Create an English Auction
   */
  function test_marketEnglish() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    deal(aliceAddress, 1.1 ether);
    mintAndTransfer(aliceAddress, 50e18);

    address bobAddress = makeAddr("Bob");
    deal(bobAddress, 1.1 ether);
    mintAndTransfer(bobAddress, 50e18);

    address tedAddress = makeAddr("Ted");
    deal(tedAddress, 1.1 ether);
    mintAndTransfer(tedAddress, 50e18);

    // Mint an entity
    vm.prank(GameConfig.getGm());
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      0x11111111111111111111111111111111, toBytes32(aliceAddress)
    );

    // Create a list price entry
    vm.prank(aliceAddress);
    bytes32 aId = IWorld(worldAddress).wrilya__marketCreateEnglishLot(
      entityId, 10 hours, 10e18
    );

    // Have Bob put in a bid
    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 11e18);

    vm.prank(tedAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 12e18);

    vm.warp(block.timestamp + 11 hours);

    vm.prank(tedAddress);
    IWorld(worldAddress).wrilya__marketClaimLot(aId);

    assertTrue(EntityInfo.getOwner(entityId) == toBytes32(tedAddress));
  }

  /**
   * @dev Create an English Auction
   */
  function test_marketPenny() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    deal(aliceAddress, 1.1 ether);
    mintAndTransfer(aliceAddress, 50e18);

    address bobAddress = makeAddr("Bob");
    deal(bobAddress, 1.1 ether);
    mintAndTransfer(bobAddress, 50e18);

    address tedAddress = makeAddr("Ted");
    deal(tedAddress, 1.1 ether);
    mintAndTransfer(tedAddress, 50e18);

    // Mint an entity
    vm.prank(GameConfig.getGm());
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      0x11111111111111111111111111111111, toBytes32(aliceAddress)
    );

    // Create a list price entry
    vm.prank(aliceAddress);
    bytes32 aId =
      IWorld(worldAddress).wrilya__marketCreatePennyLot(entityId, 10 hours);

    // Have Bob put in a bid
    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 0.1e18);

    vm.prank(tedAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 0.2e18);

    vm.prank(bobAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 0.7e18);

    vm.prank(tedAddress);
    IWorld(worldAddress).wrilya__marketBidLot(aId, 1.0e18);

    vm.warp(block.timestamp + 11 hours);

    vm.prank(tedAddress);
    IWorld(worldAddress).wrilya__marketClaimLot(aId);

    assertTrue(EntityInfo.getOwner(entityId) == toBytes32(tedAddress));
  }
}
