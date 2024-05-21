// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { HomeEnum, FieldEnum } from "./../common.sol";

/**
 * @title IGameSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IGameSystem {
  function app__recruitVoidsman(string calldata name, string calldata portrait, HomeEnum home) external;

  function app__dismissVoidsmen(bytes32 entityId) external;

  function app__trainVoidsman(bytes32 entityId, FieldEnum subject) external;

  function app__certifyVoidsman(bytes32 entityId) external;

  function app__levelTime(uint256 level) external pure returns (uint256);

  function app__isContract(address _address) external view returns (bool);
}