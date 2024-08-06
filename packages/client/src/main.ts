import Phaser from "phaser";

import Error from "./scenes/Error";
import Galaxy from "./scenes/Galaxy";
import Ledger from "./scenes/Ledger";
import Login from "./scenes/Login";
import Main from "./scenes/Main";
import Mission from "./scenes/Mission";
import Preload from "./scenes/Preload";
import Ship from "./scenes/Ship";
import Solar from "./scenes/Solar";
import Voidsman from "./scenes/Voidsman";
import Yard from "./scenes/Yard";

// Plugin
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin';
import UIPlugin from 'phaser3-rex-plugins/templates/ui/ui-plugin';
import InputTextPlugin from 'phaser3-rex-plugins/plugins/inputtext-plugin';



// MUD.dev
import { setup } from "./mud/setup";

// System
import Game from "./game";

// -----------------------------------------------------------------------------
// MUD Initialization
// -----------------------------------------------------------------------------
const bootTime: number = Date.now();

console.log("[Index] MUD Setup started");

const {
  components,
  systemCalls,
  network,
} = await setup();

Game.SetMUD(network, components, systemCalls);

console.log("[Index] MUD Setup: %d (ms)", Date.now() - bootTime);

// -----------------------------------------------------------------------------
/**
 * Class Boot
 * 
 * Initial Phaser Scene that starts the "Preload" Scene.
 */
class Boot extends Phaser.Scene {

    constructor() {
        super("Boot");
    }

    preload() {

        //this.load.pack("pack", "assets/preload-asset-pack.json");
    }

    create() {

       this.scene.start("Preload");
    }
}

// -----------------------------------------------------------------------------
window.addEventListener('load', function () {
	const game = new Phaser.Game({
		width: 1280,
		height: 720,
		backgroundColor: "#2f2f2f",
		parent: "phaser-wrilya",
		scale: {
			mode: Phaser.Scale.ScaleModes.FIT,
			autoCenter: Phaser.Scale.Center.CENTER_BOTH
		},
		scene: [
            Boot, 
            Error,
            Galaxy,
            Ledger,
            Login,
            Main,
            Mission,
            Preload,
            Ship,
            Solar,
            Voidsman,
            Yard
        ],
        plugins: {
            global: [
                {
                    key: 'rexButton',
                    plugin: ButtonPlugin,
                    start: true
                },
                {
                    key: 'rexInputText',
                    plugin: InputTextPlugin,
                    start: true
                }
            ],
            scene: [
                {
                    key: 'rexUI',
                    plugin: UIPlugin,
                    mapping: 'rexUI'
                }
            ]
        }
	});
	game.scene.start("Boot");
});