
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin';
/* END-USER-IMPORTS */

export default class BtnSceneLoadForward extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// btnForwardA
		const btnForwardA = scene.add.image(0, 0, "Forward_BTNA");
		btnForwardA.scaleX = 0.5;
		btnForwardA.scaleY = 0.5;
		btnForwardA.setOrigin(0, 0);
		this.add(btnForwardA);

		// btnForward
		const btnForward = scene.add.image(0, 0, "Forward_BTN");
		btnForward.scaleX = 0.5;
		btnForward.scaleY = 0.5;
		btnForward.setOrigin(0, 0);
		this.add(btnForward);

		// recHitBox
		const recHitBox = scene.add.rectangle(0, 0, 105, 105);
		recHitBox.setOrigin(0, 0);
		this.add(recHitBox);

		this.btnForwardA = btnForwardA;
		this.btnForward = btnForward;
		this.recHitBox = recHitBox;

		/* START-USER-CTR-CODE */
		// Write your code here.
		const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
		const button = rexButton.add(this.recHitBox, {});
		button.on('click', () => {
			this.scene.scene.start(this.nextScene);
		});
		button.on('down', () => {
			this.btnForward.visible = false;
		});
		button.on('up', () => {
			this.btnForward.visible = true;
		});
		button.on('out', () => {
			this.btnForward.visible = true;
		});
		/* END-USER-CTR-CODE */
	}

	private btnForwardA: Phaser.GameObjects.Image;
	private btnForward: Phaser.GameObjects.Image;
	private recHitBox: Phaser.GameObjects.Rectangle;
	public nextScene: string = "";

	/* START-USER-CODE */

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
