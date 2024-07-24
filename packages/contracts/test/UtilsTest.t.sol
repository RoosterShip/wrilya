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
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import { console } from "forge-std/console.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";
import { UD60x18, wrap, unwrap, convert } from "@prb/math/src/UD60x18.sol";

import "../src/utils.sol";

contract UtilsTest is MudTest {

  function test_setFieldUint8() public {
    bytes32 field = 0x112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00;
    uint8 value = 165;
    assertEq(0xa52233445566778899aabbccddeeff00112233445566778899aabbccddeeff00, setFieldUint8(field, 0, value));
    assertEq(0x11a533445566778899aabbccddeeff00112233445566778899aabbccddeeff00, setFieldUint8(field, 1, value));
    assertEq(0x1122a5445566778899aabbccddeeff00112233445566778899aabbccddeeff00, setFieldUint8(field, 2, value));
    assertEq(0x112233a55566778899aabbccddeeff00112233445566778899aabbccddeeff00, setFieldUint8(field, 3, value));
    assertEq(0x11223344a566778899aabbccddeeff00112233445566778899aabbccddeeff00, setFieldUint8(field, 4, value));
  }
  
  function test_getFieldUint8() public {
    bytes32 field = 0x112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00;
    assertEq(uint8(0x11), getFieldUint8(field, 0));
    assertEq(uint8(0x22), getFieldUint8(field, 1));
    assertEq(uint8(0x33), getFieldUint8(field, 2));
    assertEq(uint8(0x44), getFieldUint8(field, 3));
  }
  
  function test_getFieldUint8Last16() public {
    bytes32 field = 0x112233445566778899aabbccddeeff0001ffeeddccbbaa998877665544332211;
    assertEq(uint8(0x01), getFieldUint8Last16(field, 0));
    assertEq(uint8(0xff), getFieldUint8Last16(field, 1));
    assertEq(uint8(0xee), getFieldUint8Last16(field, 2));
    assertEq(uint8(0xdd), getFieldUint8Last16(field, 3));
  }

  function test_incFieldUnit8() public {
    bytes32 field = 0x0000000000010000000000000000000000000000000000000000000000000000;
    (uint8 newVal, bytes32 newfield) = incFieldUint8(field, 5);
    assertEq(newVal, 2);
    assertEq(newfield, 0x0000000000020000000000000000000000000000000000000000000000000000);
  }
  function testFail_incFieldUnit8() public pure {
    bytes32 field = 0x0000000000ff0000000000000000000000000000000000000000000000000000;
    // Will throw an exception due to buffer overflow
    incFieldUint8(field, 5);
  }
  
  function test_decFieldUnit8() public {
    bytes32 field = 0x0000000000010000000000000000000000000000000000000000000000000000;
    (uint8 newVal, bytes32 newfield) = decFieldUint8(field, 5);
    assertEq(newVal, 0);
    assertEq(newfield, 0x0000000000000000000000000000000000000000000000000000000000000000);
  }

  function testFail_decFieldUnit8() public pure {
    bytes32 field = 0x0000000000000000000000000000000000000000000000000000000000000000;
    // Will throw an exception due to buffer overflow
    decFieldUint8(field, 5);
  }

  function test_sumFieldUint8() public {
    bytes32 field = 0x112233445566778899aabbccddeeff00112233445566778899aabbccddeeff00;
    assertEq(uint16(4080), sumFieldUnit8(field));
  }
  
  function test_sumFieldUint8Front() public {
    bytes32 field = 0x112233445566778899aabbccddeeff10112233445566778899aabbccddeeff01;
    assertEq(uint16(2056), sumFieldUint8First16(field));
  }
  
  function test_sumFieldUint8Back() public {
    bytes32 field = 0x112233445566778899aabbccddeeff10112233445566778899aabbccddeeff01;
    assertEq(uint16(2041), sumFieldUint8Last16(field));
  }
  
  /**
   * Basic Test for Clearing the first half of a byte field
   */
  function test_clearFieldUint8First16() public {
    bytes32 field = 0x112233445566778899aabbccddeeff10112233445566778899aabbccddeeff01;
    bytes32 expected = 0x00000000000000000000000000000000112233445566778899aabbccddeeff01;
    assertEq(expected, clearFieldUint8First16(field));
  }

  /**
   * Basic Test for Clearing the last half of a byte field
   */
  function test_clearFieldUint8Last16() public {
    bytes32 field = 0x112233445566778899aabbccddeeff10112233445566778899aabbccddeeff01;
    bytes32 expected = 0x112233445566778899aabbccddeeff1000000000000000000000000000000000;
    assertEq(expected, clearFieldUint8Last16(field));
  }

  /**
   * Basic test of the power curve math.
   */
  function test_powerCurve() public {
    uint256 base = 0.1e18;
    uint256 power = 0.427e18;
    assertEq(1, powerCurve(base, 888, power));
    assertEq(2, powerCurve(base, 1_115, power));
    assertEq(5, powerCurve(base, 10_000, power));
  }
}
