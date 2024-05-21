
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class BarArmor extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// dot_Armor_Table
		const dot_Armor_Table = scene.add.image(0, 0, "Dot_Armor_Table");
		dot_Armor_Table.setOrigin(0, 0);
		this.add(dot_Armor_Table);

		// imgDot_0
		const imgDot_0 = scene.add.image(6, 6, "Dot_Blue");
		imgDot_0.setOrigin(0, 0);
		this.add(imgDot_0);

		// imgDot_1
		const imgDot_1 = scene.add.image(36, 6, "Dot_Blue");
		imgDot_1.setOrigin(0, 0);
		this.add(imgDot_1);

		// imgDot_2
		const imgDot_2 = scene.add.image(66, 6, "Dot_Blue");
		imgDot_2.setOrigin(0, 0);
		this.add(imgDot_2);

		// imgDot_3
		const imgDot_3 = scene.add.image(96, 6, "Dot_Blue");
		imgDot_3.setOrigin(0, 0);
		this.add(imgDot_3);

		// imgDot_4
		const imgDot_4 = scene.add.image(126, 6, "Dot_Blue");
		imgDot_4.setOrigin(0, 0);
		this.add(imgDot_4);

		// imgDot_5
		const imgDot_5 = scene.add.image(156, 6, "Dot_Blue");
		imgDot_5.setOrigin(0, 0);
		this.add(imgDot_5);

		// imgDot_6
		const imgDot_6 = scene.add.image(216, 6, "Dot_Blue");
		imgDot_6.setOrigin(0, 0);
		this.add(imgDot_6);

		// imgDot_7
		const imgDot_7 = scene.add.image(186, 6, "Dot_Blue");
		imgDot_7.setOrigin(0, 0);
		this.add(imgDot_7);

		this.imgDot_0 = imgDot_0;
		this.imgDot_1 = imgDot_1;
		this.imgDot_2 = imgDot_2;
		this.imgDot_3 = imgDot_3;
		this.imgDot_4 = imgDot_4;
		this.imgDot_5 = imgDot_5;
		this.imgDot_6 = imgDot_6;

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	private imgDot_0: Phaser.GameObjects.Image;
	private imgDot_1: Phaser.GameObjects.Image;
	private imgDot_2: Phaser.GameObjects.Image;
	private imgDot_3: Phaser.GameObjects.Image;
	private imgDot_4: Phaser.GameObjects.Image;
	private imgDot_5: Phaser.GameObjects.Image;
	private imgDot_6: Phaser.GameObjects.Image;
	public value: number = 0;
	public max: number = 0;

	/* START-USER-CODE */

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
