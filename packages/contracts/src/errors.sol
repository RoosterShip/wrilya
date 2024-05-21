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
/// code: 82b42900
error Unauthorized();

/// Error raised when the caller is not valid.  Typically a contract
/// code: 48f5c3ed
error InvalidCaller();

/// The operation could not be completed because of an invalid state in the game
/// Example would be training a crew member who is already training
/// code: baf3f0f7
error InvalidState();

/// One of the supply arguments was no good
/// code: a9cb9e0d
error InvalidArgument();

/// The operation could not be done at this time.
/// code: 9488aaa6
error NotReady();

/// This name is already in use
/// code: 023cabe9
error NameInUse();

/// Error for when the game is not currently running but some operation was requested
/// code: e76abfdd
error GameInactive();