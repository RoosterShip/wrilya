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

import {UD60x18, wrap, unwrap, convert, UNIT} from "@prb/math/src/UD60x18.sol";

// Wrilya Table imports
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {Command} from "../src/codegen/common.sol";
import "../src/codegen/index.sol";
import "../src/utils.sol";
import "../src/errors.sol";
import "../src/checks.sol";

contract LedgerSystemTest is MudTest {
  uint256 constant _mtAmount = 10_000e18;

  //----------------------------------------------------------------------------
  // Helper
  //----------------------------------------------------------------------------

  function mintAndTransfer(address addr_) private {
    deal(GameConfig.getGovernor(), 1.1 ether);

    vm.startPrank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(_mtAmount);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(addr_, _mtAmount);
    vm.stopPrank();
  }

  //----------------------------------------------------------------------------
  // Ledger Balance Check
  //----------------------------------------------------------------------------

  /**
   * @dev Verify the ledgerTokenBalanceOf call
   */
  function test_ledgerTokenBalanceOf() public {
    address aliceAddress = makeAddr("Alice");
    assertEq(
      0,
      IWorld(worldAddress).wrilya__ledgerTokenBalanceOf(toBytes32(aliceAddress))
    );

    mintAndTransfer(aliceAddress);
    assertEq(
      _mtAmount,
      IWorld(worldAddress).wrilya__ledgerTokenBalanceOf(toBytes32(aliceAddress))
    );
  }

  //----------------------------------------------------------------------------
  // Ledger Transfer Test
  //----------------------------------------------------------------------------

  /**
   * @dev Ledger Transfer Tests
   */
  function test_ledgerTransfer_account() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");

    // Mint some initial tokens
    mintAndTransfer(aliceAddress);

    // Transfer tokens to Bob
    vm.prank(aliceAddress);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(bobAddress, 1e18);
    assertEq(_mtAmount - 1e18, LedgerInfo.getTokens(toBytes32(aliceAddress)));
    assertEq(1e18, LedgerInfo.getTokens(toBytes32(bobAddress)));

    // Test Failure: Address 0
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(address(0), 1e18);

    // Test Failure: Banned Sender
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddress);
    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(bobAddress, 1e18);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedReleasePerm(aliceAddress);

    // Test Failure: Banned Receiver
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddress);
    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(bobAddress, 1e18);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedReleasePerm(bobAddress);

    // Test Failure: Insufficient Funds
    vm.prank(aliceAddress);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(bobAddress, _mtAmount);
  }

  /**
   * @dev Ledger Transfer Tests to Entity
   */
  function test_ledgerTransfer_entity() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");
    bytes16 offChainRef = 0x11111111111111111111111111111111;

    // Mint some initial tokens
    mintAndTransfer(aliceAddress);

    // Mint an entity
    vm.prank(GameConfig.getGm());
    bytes32 entityId = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef, toBytes32(aliceAddress)
    );

    // Transfer tokens to the Voidsman
    vm.prank(aliceAddress);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(entityId, 1e18);
    assertEq(_mtAmount - 1e18, LedgerInfo.getTokens(toBytes32(aliceAddress)));
    assertEq(1e18, LedgerInfo.getTokens(entityId));

    // Test Failure: EntityId 0
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(bytes32(0), 1e18);

    // Test Failure: Account transfer as a system entity
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      toBytes32(bobAddress), 1e18
    );

    // Test Failure: Invalid EntityId
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidOwner.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      bytes32(uint256(entityId) + 1), 1e18
    );

    // Test Failure: Banned Sender
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddress);
    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(entityId, 1e18);
  }

  /**
   * @dev Ledger Transfer Tests to Entity
   */
  function test_ledgerTransfer_entityToReceiver() public {
    // Basic Transfer test
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");
    bytes16 offChainRef_1 = 0x11111111111111111111111111111111;
    bytes16 offChainRef_2 = 0x22222222222222222222222222222222;

    // Mint some initial tokens
    mintAndTransfer(aliceAddress);

    vm.prank(GameConfig.getGm());
    bytes32 entityId_1 = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef_1, toBytes32(aliceAddress)
    );

    vm.prank(GameConfig.getGm());
    bytes32 entityId_2 = IWorld(worldAddress).wrilya__voidsmanMint(
      offChainRef_2, toBytes32(bobAddress)
    );

    // Transfer tokens into the Voidsman
    vm.prank(aliceAddress);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(entityId_1, 6e18);

    vm.prank(aliceAddress);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, toBytes32(bobAddress), 2e18
    );

    vm.prank(aliceAddress);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, entityId_2, 1e18
    );

    assertEq(_mtAmount - 6e18, LedgerInfo.getTokens(toBytes32(aliceAddress)));
    assertEq(3e18, LedgerInfo.getTokens(entityId_1));
    assertEq(2e18, LedgerInfo.getTokens(toBytes32(bobAddress)));
    assertEq(1e18, LedgerInfo.getTokens(entityId_2));

    // Test Failure: from EntityId not Entity
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      toBytes32(aliceAddress), toBytes32(bobAddress), 1e18
    );

    vm.prank(aliceAddress);
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      bytes32(0), toBytes32(bobAddress), 1e18
    );

    // Test Failure: sender not owner of from
    vm.prank(bobAddress);
    vm.expectRevert(InvalidOwner.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, toBytes32(bobAddress), 1e18
    );

    // Test Failure: receiver doesn't have valid owner
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidOwner.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, bytes32(uint256(entityId_2) + 1), 1e18
    );

    // Test Failure: receiver doesn't have valid owner
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidOwner.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, bytes32(uint256(entityId_2) + 1), 1e18
    );

    // Test Failure: Overdraft
    vm.prank(aliceAddress);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, entityId_2, 10e18
    );

    // Test Failure: Receiver Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddress);

    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, toBytes32(bobAddress), 2e18
    );

    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, entityId_2, 2e18
    );

    // Test Failure: Sender Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddress);

    vm.prank(aliceAddress);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      entityId_1, toBytes32(aliceAddress), 1e18
    );
  }

  /**
   * @dev Ledger Transfer Tests to Entity
   */
  function test_ledgerTransfer_currencyProxy() public {
    address aliceAddress = makeAddr("Alice");
    address bobAddress = makeAddr("Bob");

    // Mint some initial tokens
    mintAndTransfer(aliceAddress);

    // Transfer from Currency Proxy
    vm.prank(GameConfig.getCurrencyProxy());
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, bobAddress, 2e18
    );

    assertEq(_mtAmount - 2e18, LedgerInfo.getTokens(toBytes32(aliceAddress)));
    assertEq(2e18, LedgerInfo.getTokens(toBytes32(bobAddress)));

    // Test Failure:  Non Currency Proxy
    vm.prank(aliceAddress);
    vm.expectRevert(InvalidCaller.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, bobAddress, 2e18
    );

    // Test Failure:  Zero Address
    vm.prank(GameConfig.getCurrencyProxy());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      address(0), bobAddress, 2e18
    );

    vm.prank(GameConfig.getCurrencyProxy());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, address(0), 2e18
    );

    // Test Failure:  Insuffent Funds
    vm.prank(GameConfig.getCurrencyProxy());
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, bobAddress, _mtAmount
    );

    // Test Failure: Banned Accounts
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(bobAddress);

    vm.prank(GameConfig.getCurrencyProxy());
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, bobAddress, 2e18
    );

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedReleasePerm(bobAddress);
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddress);

    vm.prank(GameConfig.getCurrencyProxy());
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(
      aliceAddress, bobAddress, 2e18
    );
  }

  //----------------------------------------------------------------------------
  // Ledger Stake Tests
  //----------------------------------------------------------------------------
  function test_ledgerStake() public {
    address aliceAddr = makeAddr("Alice");
    mintAndTransfer(aliceAddr);

    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerStake(1000e18);
    assertEq(1000e18, LedgerInfo.getStaked(toBytes32(aliceAddr)));

    // Bill more then the base level
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 2000e18);
    assertEq(2000e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(_mtAmount - 1000e18, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    // Failure: To much staked value
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxStake(4000e18);

    vm.prank(aliceAddr);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__ledgerStake(8000e18);

    // Failure: InsuffientFunds
    vm.prank(aliceAddr);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerStake(_mtAmount);

    // Failure: Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    vm.prank(aliceAddr);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerPayment(100e18);
  }

  //----------------------------------------------------------------------------
  // Ledger UnStake Tests
  //----------------------------------------------------------------------------
  function test_ledgerUnstake() public {
    address aliceAddr = makeAddr("Alice");
    mintAndTransfer(aliceAddr);

    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerStake(1000e18);

    assertEq(1000e18, LedgerInfo.getStaked(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getUnstaked(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getUts(toBytes32(aliceAddr)));
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerUnstake(100e18);

    assertEq(900e18, LedgerInfo.getStaked(toBytes32(aliceAddr)));
    assertEq(100e18, LedgerInfo.getUnstaked(toBytes32(aliceAddr)));
    assertTrue(0 < LedgerInfo.getUts(toBytes32(aliceAddr)));
    // Cleanup
    vm.warp(block.timestamp + 31 days);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerClaim();

    // Failure: Double Unstake
    vm.prank(aliceAddr);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__ledgerClaim();

    // Failure: Insuffient Funds
    vm.prank(aliceAddr);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerUnstake(1000e18);

    // Failure: Out of Bounds
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__ledgerTuningSetMaxUnstake(50e18);

    vm.prank(aliceAddr);
    vm.expectRevert(OutOfBounds.selector);
    IWorld(worldAddress).wrilya__ledgerUnstake(100e18);

    // Failure: Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    vm.prank(aliceAddr);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerUnstake(1e18);
  }

  //----------------------------------------------------------------------------
  // Ledger Claim Tests
  //----------------------------------------------------------------------------
  function test_ledgerClaim() public {
    address aliceAddr = makeAddr("Alice");
    mintAndTransfer(aliceAddr);

    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerStake(1000e18);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerUnstake(1000e18);
    vm.warp(block.timestamp + 31 days);

    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerClaim();

    assertEq(0, LedgerInfo.getStaked(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getUnstaked(toBytes32(aliceAddr)));
    assertEq(_mtAmount, LedgerInfo.getTokens(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getUts(toBytes32(aliceAddr)));

    // Failure: Nothing to Claim
    vm.prank(aliceAddr);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__ledgerClaim();

    // Set us back up for a claim again
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerStake(1000e18);
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerUnstake(500e18);

    // Failure: Not ready
    vm.prank(aliceAddr);
    vm.expectRevert(InvalidState.selector);
    IWorld(worldAddress).wrilya__ledgerClaim();

    // Failure: Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    vm.prank(aliceAddr);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerClaim();
  }

  //----------------------------------------------------------------------------
  // Ledger Payment Tests
  //----------------------------------------------------------------------------
  function test_ledgerPayment() public {
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 400e18);
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerCredit(aliceAddr, 600e18);

    assertEq(400e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(600e18, LedgerInfo.getCredits(toBytes32(aliceAddr)));

    // Make Payment
    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerPayment(500e18);
    assertEq(0, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(200e18, LedgerInfo.getCredits(toBytes32(aliceAddr)));

    // Test that also covers the token pull
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 400e18);
    mintAndTransfer(aliceAddr);
    assertEq(400e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(200e18, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    assertEq(_mtAmount, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    vm.prank(aliceAddr);
    IWorld(worldAddress).wrilya__ledgerPayment(400e18);
    assertEq(0, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    assertEq(_mtAmount - 200e18, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    // Failed: Banned Address
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    vm.prank(aliceAddr);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerPayment(100e18);

    // Failed: InsufficientFunds
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(bobAddr, 400e18);

    vm.prank(bobAddr);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerPayment(400e18);
  }

  //----------------------------------------------------------------------------
  // Ledger Credit Tests
  //----------------------------------------------------------------------------
  function test_ledgerCredit() public {
    address aliceAddr = makeAddr("Alice");
    assertEq(0, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerCredit(aliceAddr, 500e18);
    assertEq(500e18, LedgerInfo.getCredits(toBytes32(aliceAddr)));

    // Failure: Non GM
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerCredit(aliceAddr, 1000e18);

    // Failure: Receiver(0)
    vm.prank(GameConfig.getGm());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerCredit(address(0), 1000e18);

    // Failure: Banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);

    vm.prank(GameConfig.getGm());
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerCredit(aliceAddr, 1000e18);
  }

  //----------------------------------------------------------------------------
  // Ledger Bill Tests
  //----------------------------------------------------------------------------
  function test_ledgerBill() public {
    address aliceAddr = makeAddr("Alice");
    address bobAddr = makeAddr("Bob");

    // Debit Covers bill
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 500e18);
    assertEq(500e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    // Debit + Credits covers bill
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerCredit(aliceAddr, 500e18);
    assertEq(500e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(500e18, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 1000e18);
    assertEq(1000e18, LedgerInfo.getDebit(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getCredits(toBytes32(aliceAddr)));
    assertEq(0, LedgerInfo.getTokens(toBytes32(aliceAddr)));

    // Debit + Credits + tokens covers bill
    mintAndTransfer(bobAddr);

    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerCredit(bobAddr, 1000e18);
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerBill(bobAddr, 3000e18);

    assertEq(1000e18, LedgerInfo.getDebit(toBytes32(bobAddr)));
    assertEq(0, LedgerInfo.getCredits(toBytes32(bobAddr)));
    assertEq(_mtAmount - 1000e18, LedgerInfo.getTokens(toBytes32(bobAddr)));

    // Failure: InsufficientFunds()
    vm.prank(GameConfig.getGm());
    IWorld(worldAddress).wrilya__ledgerCredit(bobAddr, 1000e18);

    vm.prank(GameConfig.getGm());
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__ledgerBill(bobAddr, _mtAmount + 10_000e18);

    // Failure: Receiver is address 0
    vm.prank(GameConfig.getGm());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__ledgerBill(address(0), 500e18);

    // Failure: Sender is not GM
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 1e18);

    // Failure: Receiver is banned
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(aliceAddr);
    vm.prank(GameConfig.getGm());
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__ledgerBill(aliceAddr, 500e18);
  }
}
