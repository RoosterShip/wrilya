
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin';
/* END-USER-IMPORTS */

export default class BtnCopyText extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// text
		const text = scene.add.text(0, 0, "", {});
		this.add(text);

		this.text = text;

		/* START-USER-CTR-CODE */
		const rexButton: ButtonPlugin = scene.plugins.get('rexButton') as ButtonPlugin;
		const button = rexButton.add(text, {});
		button.on('click', async () => {
			navigator.clipboard.writeText(this.text.text);
			this.text.setColor("#FFFFFF")
		});
		button.on('down', () => {
			this.text.setColor("#FFFF00")
		});
		button.on('up', () => {
			this.text.setColor("#FFFFFF")
		});
		button.on('out', () => {
			this.text.setColor("#FFFFFF")
		});
		button.on('over', () => {
			this.text.setColor("#FFFF00")
		});
		/* END-USER-CTR-CODE */
	}

	public text: Phaser.GameObjects.Text;

	/* START-USER-CODE */

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
