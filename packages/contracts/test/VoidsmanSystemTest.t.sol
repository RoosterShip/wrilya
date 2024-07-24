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
import { console } from "forge-std/console.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

// Wrilya Table imports
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";
import "../src/entity.sol";
import { EntityInfo } from "../src/codegen/index.sol";
import "../src/utils.sol";

contract VoidsmanSystemTest is MudTest {
  //---------------------------------------------------------------------------
  // Initialization Test
  //---------------------------------------------------------------------------

  /**
   * A Helper function to generate a signature for us
   */
  function genSignature() internal returns (address, bytes16, bytes16, bytes memory, address) {
    (address gmAddr, uint256 gmPK) = makeAddrAndKey("gm");
    vm.prank(vm.envAddress("TEST_GM_ADDRESS"));
    IWorld(worldAddress).wrilya__transferGM(gmAddr);

    // Now let's a new signature using
    bytes16 offchainRef = 0xEF611A1E886540648BE38F1C677594CE;
    bytes16 opId = 0xEE9F8CD6C5A94414869DAF3A4239F326;

    address aliceAddr = makeAddr("Alice");
    bytes32 digest = MessageHashUtils.toEthSignedMessageHash(
      keccak256(abi.encodePacked("voidsman_mint", aliceAddr, offchainRef, opId))
    );
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(gmPK, digest);
    bytes memory signature = abi.encodePacked(r, s, v);

    return (aliceAddr, offchainRef, opId, signature, gmAddr);
  }

  //function test_mint() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();

  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);

  //  bytes32 entityId = Entity.last();
  //  assertEq(EntityInfo.getOwner(entityId), aliceAddr);
  //}

  //function testFail_mintPaused() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //    address gmAddr
  //  ) = genSignature();
  //  // Pause the Game
  //  vm.prank(gmAddr);
  //  IWorld(worldAddress).wrilya__pause();

  //  // This should fail
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);
  //}

  //function testFail_mintReplay() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();
  //  // This should pass
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);
  //
  //  // This should fail
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);
  //}

  //function testFail_mintInvalidSender() public {
  //  (
  //    ,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();

  //  // This should pass
  //  address bobAddr = makeAddr("Bob");
  //  vm.prank(bobAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);
  //}

  //function test_burn() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();

  //  // Mint a voidsman
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);

  //  bytes32 entityId = Entity.last();
  //  assertEq(EntityInfo.getOwner(entityId), aliceAddr);

  //  // Burn the voidsman
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanBurn(entityId);
  //}

  //function testFail_doubleburn() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();

  //  // Mint a voidsman
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);

  //  bytes32 entityId = Entity.last();
  //  assertEq(EntityInfo.getOwner(entityId), aliceAddr);

  //  // Burn the voidsman
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanBurn(entityId);

  //  // Double Burn.  Should fail here
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanBurn(entityId);
  //}

  //function testFail_burnNonOwner() public {
  //  (
  //    address aliceAddr,
  //    bytes16 offchainRef,
  //    bytes16 opId,
  //    bytes memory signature,
  //  ) = genSignature();

  //  // Mint a voidsman
  //  vm.prank(aliceAddr);
  //  IWorld(worldAddress).wrilya__voidsmanMint(offchainRef, opId, signature);

  //  bytes32 entityId = Entity.last();
  //  assertEq(EntityInfo.getOwner(entityId), aliceAddr);

  //  // Burn the voidsman
  //  vm.prank(makeAddr("Bob"));
  //  IWorld(worldAddress).wrilya__voidsmanBurn(entityId);
  //}

  //function testFail_burnInvalidEntity() public {
  //  // Burn the voidsman
  //  bytes32 entityId = 0x112233445566778899aabbccddeeff10112233445566778899aabbccddeeff01;
  //  // NOTE:  I don't think this is really possible but lets make sure to get past the entity owner
  //  vm.prank(address(0));
  //  IWorld(worldAddress).wrilya__voidsmanBurn(entityId);
  //}
}
