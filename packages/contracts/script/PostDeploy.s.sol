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

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {StoreSwitch} from "@latticexyz/store/src/StoreSwitch.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {WrilyaVoteToken} from "../src/governance/vote.sol";
import {WrilyaGovernor} from "../src/governance/governor.sol";
import {WrilyaCurrencyProxy} from "../src/proxy/WrilyaCurrencyProxy.sol";
import {WrilyaItemProxy} from "../src/proxy/WrilyaItemProxy.sol";
import {WrilyaEntityProxy} from "../src/proxy/WrilyaEntityProxy.sol";
import {uMAX_WHOLE_UD60x18} from "@prb/math/src/UD60x18.sol";
import "../src/utils.sol";

/**
 * @title PostDeploy Contract
 * @author Chris Jimison
 * @notice Runs after MUD has deployed the world contract. This will deploy
 * additional system contracts and configure the enivonrment.
 *
 * NOTE:
 *
 * After the initial deployment of the system on a public chain this code
 * will not be called again.  If you need to call code post deployment then
 * create a new script and execute it using the normal foundry system:
 *
 * ```
 * forge script ./script/<YOUR NEW SCRIPT>.s.sol
 * ```
 */
contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    address gmAddress = vm.envOr("GM_ADDRESS", deployerAddress);
    address payeeAddress = vm.envOr("PAYEE_ADDRESS", deployerAddress);

    if (vm.envOr("IS_TEST", false)) {
      gmAddress = vm.envAddress("TEST_GM_ADDRESS");
      payeeAddress = vm.envAddress("TEST_PAYEE_ADDRESS");
    }

    // ------------------ Deploy Proxies ---------------------------------------
    console.log("[PostDeploy] Create Proxy Contracts");
    WrilyaCurrencyProxy wcp =
      new WrilyaCurrencyProxy(worldAddress, "WrilyaToken", "WT");
    address wcpAddress = address(wcp);

    WrilyaItemProxy wip = new WrilyaItemProxy(worldAddress);
    address wipAddress = address(wip);

    WrilyaEntityProxy wep =
      new WrilyaEntityProxy(worldAddress, "WrilyaEnity", "WE");
    address wepAddress = address(wep);

    // ------------------ Configure Game Tables --------------------------------
    console.log("[PostDeploy] Initializing Main World Contract");
    IWorld(worldAddress).wrilya__initialize(
      deployerAddress, // GM
      payeeAddress, // Payee
      deployerAddress, // GOV
      wcpAddress, // curProxy
      wipAddress, // itemProxy
      wepAddress // entityProxy
    );

    // ------------------ Configure Initial Banned Tuning Value ----------------
    console.log("[PostDeploy] Initializing Banned Tuning Values");
    IWorld(worldAddress).wrilya__bannedTuningSet(7 days);

    // ------------------ Configure Initial Ledger Tuning Value ----------------
    console.log("[PostDeploy] Initializing Ledger Tuning Values");
    IWorld(worldAddress).wrilya__ledgerTuningSet(
      1000e18, // Base Debit value all players have
      1_000_000e18, // Max Debit any player can have
      1_000_000e18, // Max Amount of Staked Tokens an account can have
      100_000e18, // Max Amount of tokens someone can unstake at time
      30 days // Time to unstake tokens
    );

    // ------------------ Configure Initial Market Tuning Value ----------------
    console.log("[PostDeploy] Initializing Market Tuning Values");
    IWorld(worldAddress).wrilya__marketTuningSet(
      10e18, // List Price Market Flat Fee
      0.02e18, // List Price Market Percentage Rake Fee (2%)
      20e18, // English Auction Market Flat Fee
      0.03e18, // English Auction Market Percentage Rake Fee (3%)
      1 hours, // English Auction Min Time on the Block
      7 days, // English Auction Max Time on the Block
      30e18, // Dutch Auction Market Flat Fee
      0.04e18, // Dutch Auction Market Percentage Rake Fee (4%)
      2 hours, // Dutch Auction Min Time on the Block
      3 days, // Dutch Auction Max Time on the Block
      40e18, // Penny Auction Market Flat Fee
      0.05e18, // Penny Auction Market Percentage Rake Fee (5%)
      4 hours, // Penny Auction Min Time on the Block
      5 days // Penny Auction Max Time on the Block
    );

    // ------------------ Configure Initial Voidsman Tuning Value --------------
    console.log("[PostDeploy] Initializing Voidsman Tuning Values");
    IWorld(worldAddress).wrilya__voidsmanGeneralTuningSet(
      10e18, // Cost to Mint a Voidman
      50_000, // Max XP a voidsman can have
      0.0994e18, // Power Curve Base for XP to Level Curve
      0.428e18 // Power Curve Power for XP to Level Curve
    );

    IWorld(worldAddress).wrilya__voidsmanSkillsTuningSet(
      10, // Max Knowledge Training Fields
      40, // Max Number of fields you can train
      220e18, // Power Curve Base for training time per level
      2.34e18, // Power Curve Power for training time per level
      10e18, // Power Curve Base for training cost per level
      6e18, // Power Curve Power for training cost per level
      10, // Max Ability Assigned Points Per Field
      1.13e18, // Power Curve Base for the Ability Points per level
      1.56e18, // Power Curve Power for the Ability Points per level
      10, // Max number of Respecs per voidsman
      100e18, // Power Curve Base cost for Respect attempt
      4e18 // Power Curve Power cost for the Respect attempt
    );

    // ------------------ Configure Currency Tuning Values  --------------------
    IWorld(worldAddress).wrilya__currencyTuningSet(
      uMAX_WHOLE_UD60x18 / 2, // The max tokens to half of what a UD60 can hold
      0.01e18, // Set the currency buy fee of 1%
      0.01e18 // Set the currency sell fee of 1%
    );

    // Initial supply of 100 million tokens created
    IWorld(worldAddress).wrilya__currencyMint{value: 1 ether}(100_000_000e18);

    uint256 tokens = IWorld(worldAddress).wrilya__ledgerTokenBalanceOf(
      toBytes32(deployerAddress)
    );

    // Give half to the game dev
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(gmAddress, 50_000_000e18);
    // ------------------ Proxy ContractsSetup ---------------------------------

    // ------------------ DAO Setup --------------------------------------------
    WrilyaVoteToken wvt = new WrilyaVoteToken(1_000_000);
    address wvtAddress = address(wvt);
    WrilyaGovernor wgc = new WrilyaGovernor(wvt, worldAddress);
    address wgcAddress = address(wgc);
    IWorld(worldAddress).wrilya__ledgerTokenTransfer(wgcAddress, 50_000_000e18);

    // ------------------ Transfer Ownership of GM and Governor ----------------
    console.log("[PostDeploy] Transfer Final Ownership to GM and Governor");
    // For test and local dev let's start the smart contract up.
    if (vm.envOr("IS_TEST", false) || vm.envOr("IS_DEV", false)) {
      IWorld(worldAddress).wrilya__currencyXchgRun();
      IWorld(worldAddress).wrilya__run();
    }
    IWorld(worldAddress).wrilya__transferGM(gmAddress);
    IWorld(worldAddress).wrilya__transferGovernor(wgcAddress);

    console.log("----------------------------------------------------");
    console.log("World Contract Deployed at: %s", worldAddress);
    console.log("Governor Contract Deployed at: %s", wgcAddress);
    console.log("Vote Contract Deployed at: %s", wvtAddress);
    console.log("Wrilya Currency Proxy Contract Deployed at: %s", wcpAddress);
    console.log("Wrilya Item Proxy Contract Deployed at: %s", wipAddress);
    console.log("Wrilya Entity Proxy Contract Deployed at: %s", wepAddress);
    console.log("----------------------------------------------------");

    vm.stopBroadcast();
  }
}
