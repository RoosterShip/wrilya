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

/**
 * @dev A bytes 32 value set to Zero
 */
bytes32 constant ZERO_BYTES32 = bytes32(0);

/**
 * @dev an Address set to zeros
 */
address constant ZERO_ADDRESS = address(0);

/**
 * @dev A Mask value to check if an ID is an entity or not
 */
bytes32 constant ENTITY_MASK =
  0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000;

uint256 constant ENTITY_OFFSET =
  uint256(0x8000000000000000000000000000000000000000000000000000000000000000);
