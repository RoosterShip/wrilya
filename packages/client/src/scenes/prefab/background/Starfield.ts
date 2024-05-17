
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Starfield extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// bg2
		const bg2 = scene.add.image(0, 0, "bg_003");
		bg2.scaleX = 0.5;
		bg2.scaleY = 0.5;
		bg2.setOrigin(0, 0);
		this.add(bg2);

		// bg1
		const bg1 = scene.add.image(1920, 0, "bg_003");
		bg1.scaleX = 0.5;
		bg1.scaleY = 0.5;
		bg1.setOrigin(0, 0);
		this.add(bg1);

		/* START-USER-CTR-CODE */
		scene.events.on('update', this.update, this);
		/* END-USER-CTR-CODE */
	}

	public velocity: number = 0;

	/* START-USER-CODE */

	update(time: number, delta: number) {
		const bg1: Phaser.GameObjects.Image = this.getAt(0);
		const bg2: Phaser.GameObjects.Image = this.getAt(1);

		if (bg1 && bg2) {
			bg1.setX(bg1.x - (this.velocity * delta));
			bg2.setX(bg2.x - (this.velocity * delta));

			if (bg1.x < -1919)
				bg1.setX(1919)
			if (bg2.x < -1919)
				bg2.setX(1919)
		}

	}
	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
