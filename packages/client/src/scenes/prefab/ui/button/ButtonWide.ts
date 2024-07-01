
// You can write more code here

/* START OF COMPILED CODE */

import ButtonStd from "./ButtonStd";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class ButtonWide extends ButtonStd {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// button_wide_d
		const button_wide_d = scene.add.image(0, 0, "button_wide_d");
		button_wide_d.setOrigin(0, 0);
		this.add(button_wide_d);

		// button_wide_h
		const button_wide_h = scene.add.image(0, 0, "button_wide_h");
		button_wide_h.setOrigin(0, 0);
		this.add(button_wide_h);

		// button_wide_p
		const button_wide_p = scene.add.image(0, 0, "button_wide_p");
		button_wide_p.setOrigin(0, 0);
		this.add(button_wide_p);

		// button_wide_n
		const button_wide_n = scene.add.image(0, 0, "button_wide_n");
		button_wide_n.setOrigin(0, 0);
		this.add(button_wide_n);

		// rec_hit_box
		const rec_hit_box = scene.add.rectangle(0, 0, 161, 28);
		rec_hit_box.setOrigin(0, 0);
		this.add(rec_hit_box);

		// text
		const text = scene.add.text(84, 15, "", {});
		text.setOrigin(0.5, 0.5);
		text.text = "Button";
		text.setStyle({ "align": "center", "fontFamily": "Eurostile Bold Extended", "fontSize": "20px", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
		this.add(text);

		/* START-USER-CTR-CODE */
		text.text = this.label;
		this.setup(
			rec_hit_box,
			button_wide_n,
			button_wide_p,
			button_wide_h,
			button_wide_d
		);
		/* END-USER-CTR-CODE */
	}

	public label: string = "Button";

	/* START-USER-CODE */

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
