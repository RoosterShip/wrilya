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

/// Error raised when the caller is not authorized to perform the action
error Unauthorized();

/// Error raised when the caller is not valid.  Typically a contract
error InvalidCaller();

/// The operation could not be completed because of an invalid state in the game
/// Example would be training a crew member who is already training
error InvalidState();

/// The operation could not be done at this time.
error NotReady();