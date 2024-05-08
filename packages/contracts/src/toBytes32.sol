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
