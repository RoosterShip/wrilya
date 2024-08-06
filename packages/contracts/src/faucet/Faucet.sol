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
//
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Faucet
 * @author Chris Jimison
 * @notice  A simple faucet contract that can pay out a batch of address
 *          a given amount.  This contract was designed to work with
 *          and offchain owner who would batch up the requests and send
 *          it down in one block instead of making multiple calls.
 */
contract Faucet is Ownable {
  /**
   * @dev Sending the funds off failed for some reason
   * code: 81063e51
   */
  error SendFailed(address);

  /**
   * @dev Constructor.  Marks the caller as the owner of the contract
   */
  constructor() Ownable(msg.sender) {}

  /**
   * @dev It is possible that over time that eth can build up in the contract.  This
   * call will drain out that left over eth.
   *
   * Example:
   *
   * sent 4 wei to pay 3 addresses, this would pay each address 1 wei and one
   * left
   * to the contract.  This call will allow the owner to recapture those funds
   * @param _address to send leftover balance
   */
  function drain(address payable _address) public onlyOwner {
    (bool success,) = _address.call{value: address(this).balance}("");
    require(success, SendFailed(_address));
  }

  /**
   * @dev Batch call to drip some funds to a collection of addresses.
   * @param _addresses to fauct funds to
   */
  function drip(address payable[] calldata _addresses) public payable {
    uint256 count = _addresses.length;
    uint256 amount = msg.value / count;
    for (uint256 i = 0; i < count; ++i) {
      address addr = _addresses[i];
      (bool success,) = addr.call{value: amount}("");
      require(success, SendFailed(addr));
    }
  }
}
