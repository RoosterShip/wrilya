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

  function game__voidsmanUpdateTrain(bytes32 entityId, FieldEnum subject) external;

  function game__voidsmanUpdateCancel(bytes32 entityId) external;

  function game__voidsmanUpdateCertify(bytes32 entityId) external;

  function game__voidsmanTrainingRequirements(
    FieldEnum filed,
    uint8 level,
    uint256 cost,
    uint256 xp,
    uint8[] calldata competencies,
    uint8[] calldata stats
  ) external;

  function game__levelTime(uint256 level) external pure returns (uint256);
}
