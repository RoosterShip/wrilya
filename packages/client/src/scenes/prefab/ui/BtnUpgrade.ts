
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin.js';
/* END-USER-IMPORTS */

export default class BtnUpgrade extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// btnMainA
		const btnMainA = scene.add.image(0, 0, "Upgrade_BTNA");
		btnMainA.setOrigin(0, 0);
		this.add(btnMainA);

		// btnMain
		const btnMain = scene.add.image(0, 0, "Upgrade_BTN");
		btnMain.setOrigin(0, 0);
		this.add(btnMain);

		// hbMain
		const hbMain = scene.add.rectangle(0, 0, 210, 210);
		hbMain.setOrigin(0, 0);
		this.add(hbMain);

		/* START-USER-CTR-CODE */
		const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
		const button = rexButton.add(hbMain, {});
		button.on('click', () => {
			this.onClick();
		});
		button.on('down', () => {
			btnMain.visible = false;
			this.onDown();
		});
		button.on('up', () => {
			btnMain.visible = true;
			this.onUp();
		});
		button.on('out', () => {
			btnMain.visible = true;
			this.onOut();
		});
		/* END-USER-CTR-CODE */
	}

	/* START-USER-CODE */

	public onDown: () => void = () => { };
	public onUp: () => void = () => { };
	public onOut: () => void = () => { };
	public onClick: () => void = () => { };

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
