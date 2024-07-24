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

import {Command, Notice} from "./codegen/common.sol";
import {CommandNonce, Commands, Notices} from "./codegen/index.sol";

library Offchain {

  /**
   * @dev Issues a command from the chain to the offchain services
   * @param cmd_ type sent to the server
   * @param data_ payload attached to command.  Each command can have a unique payload
   */
  function issue(Command cmd_, bytes memory data_) public returns(bytes32 id) {
    uint256 val = CommandNonce.get() + 1;
    CommandNonce.set(val);
    id = bytes32(val);
    Commands.set(id, cmd_, data_);
  } 

  /**
   * @dev Sends a notice to the offchain system.  This does not expect any handling
   * @param noc_ type sent to the server
   * @param data_ payload attached to command.  Each notice can have a unique payload
   */
  function send(Notice noc_, bytes memory data_) public{
    Notices.set(noc_, data_);
  } 

  /**
   * @dev Get the last command ID issued. This is really more a debugging thing and shouldn't
   * be needed in production systems
   */
  function lastCommand() public view returns(bytes32) {
    return bytes32(CommandNonce.get());
  }

}