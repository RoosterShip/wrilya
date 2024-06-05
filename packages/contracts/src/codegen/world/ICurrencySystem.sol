// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title ICurrencySystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ICurrencySystem {
  function game__mint(uint256 amount) external;

  function game__stake(uint256 amount) external;

  function game__release(uint256 amount) external;

  function game__claim() external;

  function game__payment(uint256 amount) external;
}