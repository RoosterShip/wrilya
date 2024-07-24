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
import {uMAX_WHOLE_UD60x18} from "@prb/math/src/UD60x18.sol";

// Wrilya Table imports
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {Command} from "../src/codegen/common.sol";
import "../src/codegen/index.sol";
import "../src/utils.sol";
import "../src/errors.sol";

contract CurrencySystemTest is MudTest {
  //---------------------------------------------------------------------------
  // Currency Minting
  //---------------------------------------------------------------------------

  /**
   * @dev Checks to ensure that the banned logic is tracking
   */
  function test_currencyMint() public {
    // Setup
    deal(GameConfig.getGovernor(), 10 ether);
    bytes32 gov = toBytes32(GameConfig.getGovernor());
    uint256 preMint = LedgerInfo.getTokens(gov);

    // Transact
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(100e18);

    // Verify
    assertEq(LedgerInfo.getTokens(gov), (preMint + 100e18));
  }

  function test_currecyMint_failures() public {
    deal(GameConfig.getGovernor(), 10 ether);
    // Sending without funds
    vm.prank(makeAddr("Alice"));
    vm.expectRevert();
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(100e18);

    // Revert without unauthorized user
    address bob = makeAddr("Bob");
    deal(bob, 10 ether);
    vm.prank(bob);
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(100e18);

    // Bad Amount
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(0);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__currencyMint(0);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(InvalidArgument.selector);
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(0);

    // Bad Value
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(MissingPayment.selector);
    IWorld(worldAddress).wrilya__currencyMint{value: 0 ether}(100e18);

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(MissingPayment.selector);
    IWorld(worldAddress).wrilya__currencyMint(100e18);

    // Value overflow
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert();
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(
      uMAX_WHOLE_UD60x18
    );

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(OutOfBounds.selector);
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(
      uMAX_WHOLE_UD60x18 / 2
    );
  }

  //---------------------------------------------------------------------------
  // Currency Exchange State
  //---------------------------------------------------------------------------
  function test_currencyXchgState() public {
    assertTrue(CurrencyConfig.getXchgActive());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgPause();
    assertTrue(!CurrencyConfig.getXchgActive());
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgRun();
    assertTrue(CurrencyConfig.getXchgActive());
  }

  function test_currencyXchgState_failure() public {
    // Run while running
    assertTrue(CurrencyConfig.getXchgActive());
    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(SystemActiveState.selector);
    IWorld(worldAddress).wrilya__currencyXchgRun();

    // Pause while paused
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgPause();

    vm.prank(GameConfig.getGovernor());
    vm.expectRevert(SystemActiveState.selector);
    IWorld(worldAddress).wrilya__currencyXchgPause();

    // request Run from non-gm
    address alice = makeAddr("Alice");
    vm.prank(alice);
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyXchgRun();
    assertTrue(!CurrencyConfig.getXchgActive());

    // request Pause from non-gm
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgRun();

    vm.prank(alice);
    vm.expectRevert(Unauthorized.selector);
    IWorld(worldAddress).wrilya__currencyXchgPause();
    assertTrue(CurrencyConfig.getXchgActive());
  }

  //---------------------------------------------------------------------------
  // Currency Exchange Buy
  //---------------------------------------------------------------------------

  function test_currencyXchgBuy() public {
    address alice = makeAddr("alice");
    deal(alice, 10 ether);

    // Transact
    vm.prank(alice);
    uint256 amt = IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1 ether}();

    // Verify
    assertEq(amt, LedgerInfo.getTokens(toBytes32(alice)));
    assertEq(99_000_000e18, amt);
  }

  function test_currencyXchgBuy_failures() public {
    // Pause the exchange
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgPause();
    uint256 maxVal = uMAX_WHOLE_UD60x18 / 2;
    // Buy

    address alice = makeAddr("alice");
    deal(alice, maxVal);

    // Transact
    vm.prank(alice);
    vm.expectRevert(SystemActiveState.selector);
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1 ether}();

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgRun();

    // Banned account
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(alice);

    vm.prank(alice);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1 ether}();

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedReleasePerm(alice);

    // Overflow the math
    vm.prank(alice);
    vm.expectRevert();
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: maxVal / 2}();

    // Out of bounds
    vm.prank(alice);
    vm.expectRevert(OutOfBounds.selector);
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1e51 ether}();
  }

  //---------------------------------------------------------------------------
  // Currency Exchange Sell
  //---------------------------------------------------------------------------

  function test_currencyXchgSell() public {
    address alice = makeAddr("alice");
    deal(alice, 10 ether);

    vm.prank(alice);
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1 ether}();

    assertEq(9 ether, alice.balance);

    vm.prank(alice);
    IWorld(worldAddress).wrilya__currencyXchgSell(99_000_000e18);

    assertTrue(9.9 ether < alice.balance);
    assertTrue(10 ether > alice.balance);
  }

  function test_currencyXchgSell_failure() public {
    // Buy some tokens
    address alice = makeAddr("alice");
    deal(alice, 10 ether);

    vm.prank(alice);
    IWorld(worldAddress).wrilya__currencyXchgBuy{value: 1 ether}();

    // Pause the exchange
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgPause();

    // Sell some tokens
    vm.prank(alice);
    vm.expectRevert(SystemActiveState.selector);
    IWorld(worldAddress).wrilya__currencyXchgSell(99_000_000e18);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__currencyXchgRun();

    // Banned account
    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedIssuePerm(alice);

    vm.prank(alice);
    vm.expectRevert(BannedAddress.selector);
    IWorld(worldAddress).wrilya__currencyXchgSell(99_000_000e18);

    vm.prank(GameConfig.getGovernor());
    IWorld(worldAddress).wrilya__bannedReleasePerm(alice);

    // Selling more then you have
    vm.prank(alice);
    vm.expectRevert(InsufficientFunds.selector);
    IWorld(worldAddress).wrilya__currencyXchgSell(100_000_000e18);
  }
}
