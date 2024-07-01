
// You can write more code here

/* START OF COMPILED CODE */

import ButtonStd from "./ButtonStd";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class ButtonNormal extends ButtonStd {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// button_normal_d
		const button_normal_d = scene.add.image(0, 0, "button_normal_d");
		button_normal_d.setOrigin(0, 0);
		this.add(button_normal_d);

		// button_normal_h
		const button_normal_h = scene.add.image(0, 0, "button_normal_h");
		button_normal_h.setOrigin(0, 0);
		this.add(button_normal_h);

		// button_normal_p
		const button_normal_p = scene.add.image(0, 0, "button_normal_p");
		button_normal_p.setOrigin(0, 0);
		this.add(button_normal_p);

		// button_normal_n
		const button_normal_n = scene.add.image(0, 0, "button_normal_n");
		button_normal_n.setOrigin(0, 0);
		this.add(button_normal_n);

		// rec_hit_box
		const rec_hit_box = scene.add.rectangle(0, 0, 106, 28);
		rec_hit_box.setOrigin(0, 0);
		this.add(rec_hit_box);

		// text
		const text = scene.add.text(53, 15, "", {});
		text.setOrigin(0.5, 0.5);
		text.text = "Button";
		text.setStyle({ "align": "center", "backgroundColor": "", "color": "#ffffffff", "fontFamily": "Eurostile Bold Extended", "fontSize": "20px", "stroke": "#ffffffff", "shadow.offsetY":1,"shadow.blur":1,"shadow.fill":true});
		this.add(text);

		this.text = text;

		/* START-USER-CTR-CODE */
		super.setup(
			rec_hit_box,
			button_normal_n,
			button_normal_p,
			button_normal_h,
			button_normal_d
		);
		scene.events.on('update', this.update, this);
		/* END-USER-CTR-CODE */
	}

	private text: Phaser.GameObjects.Text;
	public label: string = "Button";

	/* START-USER-CODE */

	// NOTE:  I can't figure out the sequence but we should have been
	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	update(time, delta) {
		this.text.text = this.label;
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
