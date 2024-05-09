
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
/* END-USER-IMPORTS */

export default class PrefabLogin extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? -22, y ?? 0);

		// window
		const window = scene.add.image(22, 0, "Window");
		window.scaleX = 0.5;
		window.scaleY = 0.5;
		this.add(window);

		// play_BTN
		const play_BTN = scene.add.image(20, 20, "Play_BTN");
		this.add(play_BTN);

		// play_BTNA
		const play_BTNA = scene.add.image(20, 20, "Play_BTNA");
		play_BTNA.visible = false;
		this.add(play_BTNA);

		// rectangle_1
		const rectangle_1 = scene.add.rectangle(20, 13, 128, 128);
		rectangle_1.scaleX = 1.4673111058893489;
		rectangle_1.scaleY = 1.5642352259719734;
		this.add(rectangle_1);

		/* START-USER-CTR-CODE */
		const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
		const button = rexButton.add(rectangle_1, {});
		button.on('click', (btn: object, go: object) =>{
			console.log("**** I was clicked %s", this.nextScene);
			this.scene.scene.start("Preload", {
				msg: "hello"
			});
		})
		button.on('down', (btn: object, go: object) =>{
			play_BTN.visible = false;
			play_BTNA.visible = true;
		})
		button.on('up', (btn: object, go: object) =>{
			play_BTN.visible = true;
			play_BTNA.visible = false;
		})
		/* END-USER-CTR-CODE */
	}

	public nextScene: string = "";

	/* START-USER-CODE */


	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
