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

// ----------------------------------------------------------------------------
// Import Block
// ----------------------------------------------------------------------------
import Phaser from "phaser";
// Plugin
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
// Asset Packs
import preloadAssetPackUrl from "../static/assets/preload-asset-pack.json";
import backgroundAssetPackUrl from "../static/assets/background-asset-pack.json";
import uiAssetPackUrl from "../static/assets/ui-asset-pack.json";
// Scenes
import Preload from "./scenes/stage/Preload";
import Crew from "./scenes/stage/Crew";
import Main from "./scenes/stage/Main";
import Market from "./scenes/stage/Market";
import Mission from "./scenes/stage/Mission";
import Ship from "./scenes/stage/Ship";
import Ships from "./scenes/stage/Ships";
import Wallet from "./scenes/stage/Wallet";
// MUD.dev
import { setup } from "./mud/setup";

// ----------------------------------------------------------------------------
// Class Boot
//
// The boot class is the first scene loaded by phaser which pretty much just
// loads some initial asset packs and setups up MUD.dev.  
//
// NOTE:
// 
// It might be better to put some of this in the Preload scene because it has a
// nice loading bar but for now we will leave it here and see what is feels
// like on a remote deploy later
// ----------------------------------------------------------------------------
class Boot extends Phaser.Scene {

  constructor() {
    super("Boot");
  }

  /**
   * Callback made after init and before create.  Not that his just loads the json
   * data and NOT the actual full assets.
   */
  preload() {
    this.load.pack("pack", preloadAssetPackUrl);
    this.load.pack("background", backgroundAssetPackUrl);
    this.load.pack("ui", uiAssetPackUrl);
  }

  /**
   * Callback for when the boot scene is created.
   * 
   * Loads MUD.dev system components and stores a reference to them in the game
   * registry for global access in other scenes 
   */
  async create() {
    const t: number = Date.now();

    console.log("[Boot.create] MUD Setup started");
    const {
      components,
      systemCalls,
      network,
    } = await setup();

    console.log("[Boot.create] MUD Setup: %d (ms)", Date.now() - t);

    this.game.registry.set('mud_components', components);
    this.game.registry.set('mud_systemCalls', systemCalls);
    this.game.registry.set('mud_network', network);

    console.log("[Boot.create] Scene Transition: Preload");

    this.scene.start("Preload");
  }
}

// ----------------------------------------------------------------------------
// Load Event Listener
//
// When the index.html page has loaded this this callback will trigger.  It
// will create the phaser game from the config provided then load the boot scene
// -----------------------------------------------------------------------------
window.addEventListener('load', function () {
  const config: Phaser.Types.Core.GameConfig = {
    width: 1280,
    height: 720,
    backgroundColor: "#2f2f2f",
    scale: {
      mode: Phaser.Scale.ScaleModes.FIT,
      autoCenter: Phaser.Scale.Center.CENTER_BOTH
    },
    scene: [
      Boot,
      Preload,
      Crew,
      Main,
      Market,
      Mission,
      Ship,
      Ships,
      Wallet,
    ],
      plugins: {
        global: [
          {
            key: 'rexButton',
            plugin: ButtonPlugin,
            start: true
          }
        ]
      }
    };
  const game = new Phaser.Game(config);

  game.scene.start("Boot");
});