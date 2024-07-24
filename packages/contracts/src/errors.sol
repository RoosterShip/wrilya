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

// NOTE:
//
// To get the error codes generated you just need to abi encode the string
// name of the error without the parenthesis
//
// Exmple:
// - Goto https://abi.hashex.org/
// - Select "Manual Parameters"
// - Select "your function" on the Functions dropdown
// - Enter the text "Unauthorized"
// - Encoded data is the error code ("82b42900")

/**
 * @dev Transaction requested by an unauthrozied user
 * code: 82b42900
 */
error Unauthorized();

/**
 * @dev Transaction requested by invalid caller type
 * code: 48f5c3ed
 */
error InvalidCaller();

/**
 * @dev Transaction requested when system was not in the correct "state"
 * code: baf3f0f7
 */
error InvalidState();

/**
 * @dev Transaction requested with supplied argument which is invalid
 * code: a9cb9e0d
 */
error InvalidArgument();

/**
 * @dev Transaction requested an operation that failed.  This could be due to
 * the signature not matching OR the operation already having been executed
 * code: 398d4d32
 */
error InvalidOperation();

/**
 * @dev The expected owner did not match what was given in
 * code: 49e27cff
 */
error InvalidOwner();

/**
 * @dev Transaction requested a multisig check that failed
 * code: 8baa579f
 */
error InvalidSignature();

/**
 * @dev Transaction requested when the system is not in a ready state
 * code: 9488aaa6
 */
error NotReady();

/**
 * @dev Transaction requested when game was in an active state not expected
 * code: e76abfdd
 */
error GameActiveState();

/**
 * @dev Transaction requested when system was in an active state not expected
 * code: e452b4df
 */
error SystemActiveState();

/**
 * @dev Transaction requested with send who does not have enough funds
 * code: 356680b7
 */
error InsufficientFunds();

/**
 * @dev Transaction requested by user who is on the perm ban list
 * code: 8cbb6cb3
 */
error PerminateBan();

/**
 * @dev Transaction requested by address that is banned
 * code: 3b64d0cf
 */
error BannedAddress();

/**
 * @dev Transaction requested error due to time expired check
 * code: 2ddeb065
 */
error TimeExpired();

/**
 * @dev Transction request to a function not implemented yet
 * code: d6234725
 */
error NotImplemented();

/**
 * @dev Transction that was expecting a payment did not include one
 * code: 62128b04
 */
error MissingPayment();

/**
 * @dev The values given will create an out of bounds result
 * code: b4120f14
 */
error OutOfBounds();
