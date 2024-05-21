// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    // ------------------ Configure Game Tables ------------------

    address addr = vm.addr(deployerPrivateKey);

    IWorld(worldAddress).game__setAdmin(addr);
    IWorld(worldAddress).game__setGM(addr);
    
    IWorld(worldAddress).game__setVoidsmanMaxCompetency(10);
    IWorld(worldAddress).game__setVoidsmanMaxStats(10);
    
    IWorld(worldAddress).game__setVoidsmanCreateCost(100);
    IWorld(worldAddress).game__setVoidsmanUpgradeTimeBase(10);
    IWorld(worldAddress).game__setVoidsmanUpgradeTimePower(6);

    IWorld(worldAddress).game__setVoidsmanUpgradeCostBase(2);
    IWorld(worldAddress).game__setVoidsmanUpgradeCostPower(6);


    // ------------------ Voidsman Setup -----------------------------

    // 

    // ------------------ Game Launch -----------------------------

    // Launch the game
    IWorld(worldAddress).game__unpause();

    vm.stopBroadcast();
  }
}
