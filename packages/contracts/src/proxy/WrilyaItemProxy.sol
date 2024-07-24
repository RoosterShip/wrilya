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

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import { IERC165, ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract WrilyaItemProxy is ERC165, IERC1155 {
  address private _world;

  constructor(address world_) {
    // Verify that the address is a contract
    _world = world_;
  }

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    return
      interfaceId == type(IERC1155).interfaceId ||
      //interfaceId == type(IERC1155MetadataURI).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  /**
   * @dev Returns the value of tokens of token type `id` owned by `account`.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   */
  function balanceOf(address account, uint256 id) external view returns (uint256) {
    return 0;
  }

  /**
   * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
   *
   * Requirements:
   *
   * - `accounts` and `ids` must have the same length.
   */
  function balanceOfBatch(
    address[] calldata accounts,
    uint256[] calldata ids
  ) external view returns (uint256[] memory batch) {
    batch[0] = 0;
  }

  /**
   * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
   *
   * Emits an {ApprovalForAll} event.
   *
   * Requirements:
   *
   * - `operator` cannot be the caller.
   */
  function setApprovalForAll(address operator, bool approved) external {}

  /**
   * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
   *
   * See {setApprovalForAll}.
   */
  function isApprovedForAll(address account, address operator) external view returns (bool) {
    return false;
  }

  /**
   * @dev Transfers a `value` amount of tokens of type `id` from `from` to `to`.
   *
   * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
   * to an untrusted contract, when invoking {onERC1155Received} on the receiver.
   * Ensure to follow the checks-effects-interactions pattern and consider employing
   * reentrancy guards when interacting with untrusted contracts.
   *
   * Emits a {TransferSingle} event.
   *
   * Requirements:
   *
   * - `to` cannot be the zero address.
   * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
   * - `from` must have a balance of tokens of type `id` of at least `value` amount.
   * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
   * acceptance magic value.
   */
  function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external {}

  /**
   * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
   *
   * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
   * to an untrusted contract, when invoking {onERC1155BatchReceived} on the receiver.
   * Ensure to follow the checks-effects-interactions pattern and consider employing
   * reentrancy guards when interacting with untrusted contracts.
   *
   * Emits either a {TransferSingle} or a {TransferBatch} event, depending on the length of the array arguments.
   *
   * Requirements:
   *
   * - `ids` and `values` must have the same length.
   * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
   * acceptance magic value.
   */
  function safeBatchTransferFrom(
    address from,
    address to,
    uint256[] calldata ids,
    uint256[] calldata values,
    bytes calldata data
  ) external {}
}
