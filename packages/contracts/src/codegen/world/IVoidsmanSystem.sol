// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { HomeEnum, FieldEnum } from "./../common.sol";

/**
 * @title IVoidsmanSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IVoidsmanSystem {
  function game__voidsmanCreate(string calldata name, string calldata portrait, HomeEnum home) external;

  function game__voidsmanDestroy(bytes32 entityId) external;

  function game__voidsmanTrain(bytes32 entityId, FieldEnum field) external;

  function game__voidsmanTrainCancel(bytes32 entityId) external;

  function game__voidsmanCertify(bytes32 entityId) external;

  function game__voidsmanSetTrainingRequirements(
    uint8 level,
    FieldEnum field,
    uint256 xp,
    uint8[] calldata comps,
    uint8[] calldata stats
  ) external;

  function game__levelTime(uint256 level) external view returns (uint256);

  function game__levelCost(uint256 level) external view returns (uint256);
}