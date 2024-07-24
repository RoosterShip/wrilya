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

import {UD60x18, unwrap, wrap, convert} from "@prb/math/src/UD60x18.sol";

/**
 * @dev Cast a address into a bytes32
 * @param address_ to convert to a bytes32
 */
function toBytes32(address address_) pure returns (bytes32) {
  return bytes32(uint256(uint160(address_)));
}

function toAddress(bytes32 address_) pure returns (address) {
  return address(uint160(uint256(address_)));
}

/**
 * @dev Set a value in a byte32 field.
 * Note:  This could be optimized a bit more by reducing casts and using
 * assembly but bang isn't worth the buck ATM
 *
 * @param field_ bytes32 bites
 * @param value_ of byte you want to set
 * @param offset_ into the bitfield the byte should be set
 */
function setFieldUint8(
  bytes32 field_,
  uint8 offset_,
  uint8 value_
) pure returns (bytes32) {
  uint8 offsetBits = offset_ * 8;
  return (bytes32(bytes1(value_)) >> offsetBits)
    | (field_ & ~(bytes32(bytes1(0xff)) >> offsetBits));
}

/**
 * @dev Get a uint8 value from a bytes32 field bitset.
 *
 * @param field_ bytes32 bites
 * @param offset_ into the bitfield to read the unit8 value
 */
function getFieldUint8(bytes32 field_, uint8 offset_) pure returns (uint8) {
  return uint8(field_[offset_]);
}

/**
 * @dev Get a uint8 value from a bytes32 field bitset.
 *
 * @param field_ bytes32 bites
 * @param offset_ into the bitfield to read the unit8 value
 */
function getFieldUint8Last16(
  bytes32 field_,
  uint8 offset_
) pure returns (uint8) {
  return uint8(field_[offset_ + 16]);
}

/**
 * @dev Increment a field.  Returns the tuple value of the new value and the
 * set field
 *
 * NOTE:  This can be further optimized with more bitwise logic.
 * In the case of incrementing a value of 255 This will throw an
 * arithmetic underflow/overflow exception at least in the Solidyt 0.8.24
 *
 * @param field_ bytes32 bites
 * @param offset_ into the bitfield to read the unit8 value
 */
function incFieldUint8(
  bytes32 field_,
  uint8 offset_
) pure returns (uint8, bytes32) {
  uint8 value = uint8(field_[offset_]) + 1;
  uint8 offsetBits = offset_ * 8;
  return (
    value,
    (bytes32(bytes1(value)) >> offsetBits)
      | (field_ & ~(bytes32(bytes1(0xff)) >> offsetBits))
  );
}

/**
 * @dev Increment a field in the last half of the data block.  Returns the
 * tuple value of the new value and the set field
 *
 * @param field_ bytes32 bites
 * @param offset_ into the bitfield to read the unit8 value
 */
function incFieldUint8Last16(
  bytes32 field_,
  uint8 offset_
) pure returns (uint8, bytes32) {
  return incFieldUint8(field_, offset_ + 16);
}

/**
 * @dev Decrement a field.  Returns the tuple value of the new value and the
 * set field
 *
 * NOTE:  This can be further optimized with more bitwise logic.
 * In the case of decrementing a value of 0 This will throw an
 * arithmetic underflow/overflow exception at least in the Solidyt 0.8.24
 *
 * @param field_ bytes32 bites
 * @param offset_ into the bitfield to read the unit8 value
 * @return uint8 new element value
 * @return bytes32 new bytefield value
 */
function decFieldUint8(
  bytes32 field_,
  uint8 offset_
) pure returns (uint8, bytes32) {
  uint8 value = uint8(field_[offset_]) - 1;
  uint8 offsetBits = offset_ * 8;
  return (
    value,
    (bytes32(bytes1(value)) >> offsetBits)
      | (field_ & ~(bytes32(bytes1(0xff)) >> offsetBits))
  );
}

/**
 * @dev sum all the uin8 values stored in a bytes32 field
 * @param field_ of uint8 values you wish to sum up
 */
function sumFieldUnit8(bytes32 field_) pure returns (uint16 sum) {
  sum += uint8(field_[0]);
  sum += uint8(field_[1]);
  sum += uint8(field_[2]);
  sum += uint8(field_[3]);
  sum += uint8(field_[4]);
  sum += uint8(field_[5]);
  sum += uint8(field_[6]);
  sum += uint8(field_[7]);
  sum += uint8(field_[8]);
  sum += uint8(field_[9]);
  sum += uint8(field_[10]);
  sum += uint8(field_[11]);
  sum += uint8(field_[12]);
  sum += uint8(field_[13]);
  sum += uint8(field_[14]);
  sum += uint8(field_[15]);
  sum += uint8(field_[16]);
  sum += uint8(field_[17]);
  sum += uint8(field_[18]);
  sum += uint8(field_[19]);
  sum += uint8(field_[20]);
  sum += uint8(field_[21]);
  sum += uint8(field_[22]);
  sum += uint8(field_[23]);
  sum += uint8(field_[24]);
  sum += uint8(field_[25]);
  sum += uint8(field_[26]);
  sum += uint8(field_[27]);
  sum += uint8(field_[28]);
  sum += uint8(field_[29]);
  sum += uint8(field_[30]);
  sum += uint8(field_[31]);
}

/**
 * @dev sum the first 16 uint8 byte values in a bytes32 field
 * @param field_ to sum the first 16 fields of
 */
function sumFieldUint8First16(bytes32 field_) pure returns (uint16 sum) {
  sum += uint8(field_[0]);
  sum += uint8(field_[1]);
  sum += uint8(field_[2]);
  sum += uint8(field_[3]);
  sum += uint8(field_[4]);
  sum += uint8(field_[5]);
  sum += uint8(field_[6]);
  sum += uint8(field_[7]);
  sum += uint8(field_[8]);
  sum += uint8(field_[9]);
  sum += uint8(field_[10]);
  sum += uint8(field_[11]);
  sum += uint8(field_[12]);
  sum += uint8(field_[13]);
  sum += uint8(field_[14]);
  sum += uint8(field_[15]);
}

/**
 * @dev sum the last 16 uint8 byte values in a bytes32 field
 * @param field_ to sum the last 16 fields of
 */
function sumFieldUint8Last16(bytes32 field_) pure returns (uint16 sum) {
  sum += uint8(field_[16]);
  sum += uint8(field_[17]);
  sum += uint8(field_[18]);
  sum += uint8(field_[19]);
  sum += uint8(field_[20]);
  sum += uint8(field_[21]);
  sum += uint8(field_[22]);
  sum += uint8(field_[23]);
  sum += uint8(field_[24]);
  sum += uint8(field_[25]);
  sum += uint8(field_[26]);
  sum += uint8(field_[27]);
  sum += uint8(field_[28]);
  sum += uint8(field_[29]);
  sum += uint8(field_[30]);
  sum += uint8(field_[31]);
}

/**
 * @dev Clear the first 16 bytes of a data field.
 * @param field_ to be cleared
 */
function clearFieldUint8First16(bytes32 field_) pure returns (bytes32) {
  return
    field_ & 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
}

/**
 * @dev Clear the last 16 bytes of a data field.
 * @param field_ to be cleared
 */
function clearFieldUint8Last16(bytes32 field_) pure returns (bytes32) {
  return
    field_ & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
}

/**
 * @dev This is a specialized implementation of a power curve so BEWARE and read
 * this
 * It is expected that the base and the power values are multiplied by `e18`.  Why?
 * So we can support fractional number so uch "0.427".  The leve is NOT meant to
 * be
 * an `e18` based number because that typically represents the current level,
 * XP, etc.
 *
 * The power curve is equal to `base_ * level_ ^ power_`
 *
 * @param base_ number multiplied by e18
 * @param level_ number NOT multiplied by e18
 * @param power_ number multiplied by by e18
 */
function powerCurve(
  uint256 base_,
  uint256 level_,
  uint256 power_
) pure returns (uint256) {
  return convert(wrap(base_).mul(wrap(level_ * 1e18).pow(wrap(power_))));
}

function percent(uint256 value_, uint256 percent_) pure returns (uint256) {
  return unwrap(wrap(value_).mul(wrap(percent_)));
}

/// Check to see if the address is a contract.
///
/// NOTE:
///
/// This isn't all that SUPER safe given you can trick it by calling this
/// function from a contract constructor.
///
/// @param address_ to check if contract
function isContract(address address_) view returns (bool) {
  uint32 size;
  assembly {
    size := extcodesize(address_)
  }
  //Warning: will return false if the call is made from the constructor of a
  // smart contract
  return (size > 0);
}
