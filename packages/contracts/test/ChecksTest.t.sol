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
import "../src/utils.sol";
import "../src/errors.sol";
import "../src/checks.sol";
import "../src/entity.sol";

contract ChecksSystemTest is MudTest {
  /**
   * @dev Checks to ensure that the banned logic is tracking
   */
  function test_isBanned() public {
    address gmAddress = GameConfig.getGm();
    address govAddress = GameConfig.getGovernor();
    address aliceAddress = makeAddr("Alice");

    assertEq(false, isBanned(aliceAddress));

    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddress);

    assertEq(true, isBanned(aliceAddress));

    vm.prank(govAddress);
    IWorld(worldAddress).wrilya__bannedReleasePerm(aliceAddress);

    assertEq(false, isBanned(aliceAddress));

    vm.prank(gmAddress);
    IWorld(worldAddress).wrilya__bannedIssueTemp(aliceAddress);

    assertEq(true, isBanned(aliceAddress));

    vm.warp(block.timestamp + 8 days);

    assertEq(false, isBanned(aliceAddress));
  }

  /**
   * @dev Test to ensure that entity checks work correctly
   */
  function test_isEntityChecks() public {
    address gmAddress = GameConfig.getGm();
    address aliceAddress = makeAddr("Alice");
    bytes16 offChainRef = 0x11111111111111111111111111111111;

    vm.prank(gmAddress);
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef, toBytes32(aliceAddress)
    );

    assertEq(false, isSystemEntity(0));
    assertEq(false, isSystemEntity(toBytes32(aliceAddress)));
    assertEq(false, isSystemEntity(toBytes32(gmAddress)));
    assertEq(true, isSystemEntity(entityId));

    assertEq(false, isAccountEntity(0));
    assertEq(true, isAccountEntity(toBytes32(aliceAddress)));
    assertEq(true, isAccountEntity(toBytes32(gmAddress)));
    assertEq(false, isAccountEntity(entityId));
  }

  /**
   * @dev Test to check if the operation is valid.  This will
   * call isValidSignature so we will not do a specific test for it.
   */
  function test_isValidOperation() public {
    (address accountAddress, uint256 accountPK) = makeAddrAndKey("some_account");
    bytes32 keccakData =
      keccak256(abi.encodePacked("some_test", bytes16(uint128(1))));
    bytes32 digest = MessageHashUtils.toEthSignedMessageHash(keccakData);
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(accountPK, digest);
    bytes memory signature = abi.encodePacked(r, s, v);

    // All good test
    assertEq(true, isValidSignature(keccakData, signature, accountAddress));

    // Address not signer
    assertEq(
      false,
      isValidSignature(keccakData, signature, makeAddr("Some Other Address"))
    );

    // Data not signatures
    bytes32 badData =
      keccak256(abi.encodePacked("some_test", bytes16(uint128(2))));
    assertEq(false, isValidSignature(badData, signature, accountAddress));
  }
}
