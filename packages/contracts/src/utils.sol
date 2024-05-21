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
import { EntityIdTable, GameConfigTable, NotificationTable } from "./codegen/index.sol";
import { OperationEnum  } from "./codegen/common.sol";
import { Unauthorized, InvalidState } from "./errors.sol";
import {IWorld} from "./codegen/world/IWorld.sol";

function newEntityID() returns (bytes32){
  uint256 entityValue = EntityIdTable.get() + 1;
  bytes32 entityId = toBytes32(entityValue);
  EntityIdTable.set(entityValue);
  return entityId;
}

function requireAdmin(address _address) view {
  if(GameConfigTable.getAdmin() != address(0) && _address != GameConfigTable.getAdmin()) {
    revert Unauthorized();
  }
}

function requireGM(address _address) view {
  if(_address != GameConfigTable.getGm()){revert Unauthorized();}
}

function requireRunning() view {
  if(!GameConfigTable.getActive()){revert InvalidState();}
}

function requireHalted() view {
  if(!GameConfigTable.getActive()){revert InvalidState();}
}

function requireCurrencyProxy(address _address) view {
  if(_address != GameConfigTable.getCurrencyProxy()){revert Unauthorized();}
}

function requireItemProxy(address _address) view {
  if(_address != GameConfigTable.getItemProxy()){revert Unauthorized();}
}

function requireEntityProxy(address _address) view {
  if(_address != GameConfigTable.getEntityProxy()){revert Unauthorized();}
}

function notify(OperationEnum op, bytes memory data) {
  NotificationTable.set(op, data);
}

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


/// Check to see if the address is a contract.  
/// 
/// NOTE:  
/// 
/// This isn't all that SUPER safe given you can trick it by calling this
/// function from a contract constructor.
///
/// @param _address to check if contract
function isContract(address _address) view returns (bool){
  uint32 size;
  assembly {
    size := extcodesize(_address)
  }
  //Warning: will return false if the call is made from the constructor of a smart contract
  return (size > 0);
}
