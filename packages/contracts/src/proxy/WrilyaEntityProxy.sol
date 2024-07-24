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

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {
  IERC165,
  ERC165
} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

import "../codegen/world/IWorld.sol";
import "../utils.sol";
import "../entity.sol";
import "../errors.sol";
import "../checks.sol";

contract WrilyaEntityProxy is ERC165, IERC721 {
  address private _world;
  string private _name;
  string private _symbol;

  constructor(address world_, string memory name_, string memory symbol_) {
    // Verify that the address is a contract
    _world = world_;
    _name = name_;
    _symbol = symbol_;
  }

  /**
   * @dev See {IERC165-supportsInterface}.
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override (ERC165, IERC165)
    returns (bool)
  {
    return interfaceId == type(IERC721).interfaceId
    //interfaceId == type(IERC721Metadata).interfaceId ||
    || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Returns the number of tokens in ``owner``'s account.
   */
  function balanceOf(address owner)
    external
    view
    virtual
    returns (uint256 balance)
  {
    balance = IWorld(_world).wrilya__entityBalanceOf(toBytes32(owner));
  }

  /**
   * @dev Returns the owner of the `tokenId` token.
   *
   * Requirements:
   *
   * - `tokenId` must exist.
   */
  function ownerOf(uint256 tokenId)
    external
    view
    virtual
    returns (address owner)
  {
    bytes32 ownerID = IWorld(_world).wrilya__entityOwnerOf(bytes32(tokenId));
    require(isSystemEntity(ownerID), InvalidArgument());
    assembly {
      owner := and(ownerID, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
    }
  }

  /**
   * @dev Safely transfers `tokenId` token from `from` to `to`.
   *
   * Requirements:
   *
   * - `from` cannot be the zero address.
   * - `to` cannot be the zero address.
   * - `tokenId` token must exist and be owned by `from`.
   * - If the caller is not `from`, it must be approved to move this token by
   * either {approve} or {setApprovalForAll}.
   * - If `to` refers to a smart contract, it must implement
   * {IERC721Receiver-onERC721Received}, which is called upon
   *   a safe transfer.
   *
   * Emits a {Transfer} event.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata
  ) external {
    //bytes32 fromEntity = toBytes32(from);
    //bytes32 toEntity = toBytes32(to);
  }

  /**
   * @dev Safely transfers `tokenId` token from `from` to `to`, checking first
   * that contract recipients
   * are aware of the ERC721 protocol to prevent tokens from being forever
   * locked.
   *
   * Requirements:
   *
   * - `from` cannot be the zero address.
   * - `to` cannot be the zero address.
   * - `tokenId` token must exist and be owned by `from`.
   * - If the caller is not `from`, it must have been allowed to move this token
   * by either {approve} or
   *   {setApprovalForAll}.
   * - If `to` refers to a smart contract, it must implement
   * {IERC721Receiver-onERC721Received}, which is called upon
   *   a safe transfer.
   *
   * Emits a {Transfer} event.
   */
  function safeTransferFrom(address from, address to, uint256 tokenId) external {}

  /**
   * @dev Transfers `tokenId` token from `from` to `to`.
   *
   * WARNING: Note that the caller is responsible to confirm that the recipient
   * is capable of receiving ERC721
   * or else they may be permanently lost. Usage of {safeTransferFrom} prevents
   * loss, though the caller must
   * understand this adds an external call which potentially creates a
   * reentrancy vulnerability.
   *
   * Requirements:
   *
   * - `from` cannot be the zero address.
   * - `to` cannot be the zero address.
   * - `tokenId` token must be owned by `from`.
   * - If the caller is not `from`, it must be approved to move this token by
   * either {approve} or {setApprovalForAll}.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address from, address to, uint256 tokenId) external {}

  /**
   * @dev Gives permission to `to` to transfer `tokenId` token to another
   * account.
   * The approval is cleared when the token is transferred.
   *
   * Only a single account can be approved at a time, so approving the zero
   * address clears previous approvals.
   *
   * Requirements:
   *
   * - The caller must own the token or be an approved operator.
   * - `tokenId` must exist.
   *
   * Emits an {Approval} event.
   */
  function approve(address to, uint256 tokenId) external {}

  /**
   * @dev Approve or remove `operator` as an operator for the caller.
   * Operators can call {transferFrom} or {safeTransferFrom} for any token owned
   * by the caller.
   *
   * Requirements:
   *
   * - The `operator` cannot be the address zero.
   *
   * Emits an {ApprovalForAll} event.
   */
  function setApprovalForAll(address operator, bool approved) external {}

  /**
   * @dev Returns the account approved for `tokenId` token.
   *
   * Requirements:
   *
   * - `tokenId` must exist.
   */
  function getApproved(uint256 tokenId)
    external
    view
    returns (address operator)
  {}

  /**
   * @dev Returns if the `operator` is allowed to manage all of the assets of
   * `owner`.
   *
   * See {setApprovalForAll}
   */
  function isApprovedForAll(
    address owner,
    address operator
  ) external view returns (bool) {}
}
