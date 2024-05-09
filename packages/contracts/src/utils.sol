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

pragma solidity >=0.8.24;

// Convert argument to a bytes32

function toBytes32(address addr) pure returns (bytes32) {
  return bytes32(uint256(uint160(addr)));
}

function toBytes32(bytes16 n) pure returns (bytes32) {
  return bytes32(n);
}

function toBytes32(uint256 n) pure returns (bytes32) {
  return bytes32(n);
}

/// Set a value in a byte32 field.
///
/// note: This implementation can be much better if we use and bitwise or
///       operators, however I couldn't figure out the sytax around casting
///       uint8s into byte32, so I went with the next easist implementation
///       which was to use array notation.
///
/// NOT PRODUCTION CODE!!!!!
///
/// @param field bytes32 bites
/// @param value of byte you want to set
/// @param offset into the bitfield the byte should be set
function setFieldUint8(bytes32 field, uint8 value, uint8 offset) pure returns (bytes32 result) {
  bytes memory holder = bytes.concat(field);
  holder[offset] = bytes1(value);
  assembly {
    result := mload(add(holder, 32))
  }
}

/// Get a uint8 value from a bytes32 field bitset
/// @param field bytes32 bites
/// @param offset into the bitfield to read the unit8 value
function getFieldUint8(bytes32 field, uint8 offset) pure returns (uint8) {
  return uint8(field[offset]);
}
