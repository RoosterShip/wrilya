
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import BtnSceneLoadBack from "../prefab/ui/BtnSceneLoadBack";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Ship extends Phaser.Scene {

	constructor() {
		super("Ship");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// btnSceneLoadBack
		const btnSceneLoadBack = new BtnSceneLoadBack(this, 0, 615);
		this.add.existing(btnSceneLoadBack);

		// text_1
		const text_1 = this.add.text(0, 0, "", {});
		text_1.text = "Ship Scene";
		text_1.setStyle({ "fontSize": "64px" });

		// btnSceneLoadBack (prefab fields)
		btnSceneLoadBack.nextScene = "Ships";

		this.events.emit("scene-awake");
	}

	/* START-USER-CODE */

	// Write your code here

	create() {

		this.editorCreate();
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
