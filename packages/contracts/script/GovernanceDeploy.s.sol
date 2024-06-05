// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import "../src/governance/vote.sol";
import "../src/governance/governor.sol";

contract GovernanceDeploy is Script {
  function setUp() public {}

  function run() public {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("GOVERNANCE_PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Deploying the WrilyaVote token contract");
    WrilyaVoteToken wvt = new WrilyaVoteToken();

    address wvtAddr = address(wvt);

    console.log("Voting Token Address: %s", wvtAddr);
    
    console.log("Deploying WrilyaGovernor contract");

    WrilyaGovernor wgc = new WrilyaGovernor(wvt);
    address wgcAddr = address(wgc);

    console.log("Governor Contract Address: %s", wgcAddr);

    console.log("Deployment Complete");

    vm.stopBroadcast();
  }
}
