// SPDX-License-Identifier: MIT
pragma solidity >=0.8.26;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";

contract DisableWrilya is Script {
  function run() external {
    uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
    address worldAddress = 0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B;

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    // ------------------ Configure Initial Banned Tuning Value ----------------
    console.log("[EnableWrilya] Turn on the system");
    IWorld(worldAddress).wrilya__run();

    vm.stopBroadcast();
  }
}
