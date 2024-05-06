import Phaser from "phaser";
import Level from "./scenes/Level";
import preloadAssetPackUrl from "../static/assets/preload-asset-pack.json";
import Preload from "./scenes/Preload";
import { setup } from "./mud/setup";
import mudConfig from "contracts/mud.config";

import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';

// Setup the MUD framework
const {
  components,
  systemCalls: { increment },
  network,
} = await setup();

class Boot extends Phaser.Scene {

    constructor() {
        super("Boot");
    }

    preload() {

        this.load.pack("pack", preloadAssetPackUrl);
        this.load.pack("background", preloadAssetPackUrl);
        this.load.pack("ui", preloadAssetPackUrl);
    }

    create() {

       this.scene.start("Preload");
    }
}

window.addEventListener('load', function () {
	const config: Phaser.Types.Core.GameConfig = {
		width: 1280,
		height: 720,
		backgroundColor: "#2f2f2f",
		scale: {
			mode: Phaser.Scale.ScaleModes.FIT,
			autoCenter: Phaser.Scale.Center.CENTER_BOTH
		},
		scene: [Boot, Preload, Level],
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