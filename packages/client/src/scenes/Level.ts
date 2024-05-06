
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import PrefabLogin from "./PrefabLogin";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Level extends Phaser.Scene {

	constructor() {
		super("Level");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// prefabLogin
		const prefabLogin = new PrefabLogin(this, 615, 381);
		this.add.existing(prefabLogin);

		// prefabLogin (prefab fields)
		prefabLogin.nextScene = "Game Scene";

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
