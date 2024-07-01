
// You can write more code here

/* START OF COMPILED CODE */

import ButtonStd from "./ButtonStd";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class ButtonSmallClose extends ButtonStd {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// button_close_d
		const button_close_d = scene.add.image(0, 0, "button_close_d");
		button_close_d.setOrigin(0, 0);
		this.add(button_close_d);

		// button_close_h
		const button_close_h = scene.add.image(0, 0, "button_close_h");
		button_close_h.setOrigin(0, 0);
		this.add(button_close_h);

		// button_close_p
		const button_close_p = scene.add.image(0, 0, "button_close_p");
		button_close_p.setOrigin(0, 0);
		this.add(button_close_p);

		// button_close_n
		const button_close_n = scene.add.image(0, 0, "button_close_n");
		button_close_n.setOrigin(0, 0);
		this.add(button_close_n);

		// rec_hit_box
		const rec_hit_box = scene.add.rectangle(0, 0, 27, 27);
		rec_hit_box.setOrigin(0, 0);
		this.add(rec_hit_box);

		/* START-USER-CTR-CODE */
		this.setup(
			rec_hit_box,
			button_close_n,
			button_close_p,
			button_close_h,
			button_close_d
		);
		/* END-USER-CTR-CODE */
	}

	/* START-USER-CODE */

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
