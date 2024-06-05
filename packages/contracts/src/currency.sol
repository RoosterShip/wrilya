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
import { CurrencyTable, GameConfigTable } from "./codegen/index.sol";

import { InsufficientFunds } from "./errors.sol";

function invoice(bytes32 owner, uint256 amount) {
    uint256 debit = CurrencyTable.getDebit(owner) + amount;
    if(debit > maxDebit(owner) ) revert InsufficientFunds();
    CurrencyTable.setDebit(owner, debit);
}

function maxDebit(bytes32 owner) view returns (uint256){
    return GameConfigTable.getStdMaxDebit() + (CurrencyTable.getStaked(owner) * GameConfigTable.getCollateralDebitRatio());
}
