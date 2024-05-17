
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import Starfield from "../prefab/background/Starfield";
import BtnSceneLoadText from "../prefab/ui/BtnSceneLoadText";
/* START-USER-IMPORTS */
import Game from "../../game";
/* END-USER-IMPORTS */

export default class Main extends Phaser.Scene {

	constructor() {
		super("Main");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// starfield
		const starfield = new Starfield(this, 0, 0);
		this.add.existing(starfield);
		starfield.name = "starfield";

		// btnCrew
		const btnCrew = new BtnSceneLoadText(this, 1000, 100);
		this.add.existing(btnCrew);
		btnCrew.name = "btnCrew";
		btnCrew.removeInteractive();
		btnCrew.setInteractive(new Phaser.Geom.Rectangle(0, 0, 154, 67), Phaser.Geom.Rectangle.Contains);
		btnCrew.text = "Crew";
		btnCrew.setStyle({ "fontSize": "64px" });

		// btnShips
		const btnShips = new BtnSceneLoadText(this, 1000, 200);
		this.add.existing(btnShips);
		btnShips.removeInteractive();
		btnShips.setInteractive(new Phaser.Geom.Rectangle(0, 0, 193, 67), Phaser.Geom.Rectangle.Contains);
		btnShips.text = "Ships";
		btnShips.setStyle({ "fontSize": "64px" });

		// btnMission
		const btnMission = new BtnSceneLoadText(this, 1000, 300);
		this.add.existing(btnMission);
		btnMission.name = "btnMission";
		btnMission.removeInteractive();
		btnMission.setInteractive(new Phaser.Geom.Rectangle(0, 0, 269, 67), Phaser.Geom.Rectangle.Contains);
		btnMission.text = "Mission";
		btnMission.setStyle({ "fontSize": "64px" });

		// lblWrilya
		const lblWrilya = this.add.text(24, 32, "", {});
		lblWrilya.text = "Wrilya";
		lblWrilya.setStyle({ "fontSize": "128px" });

		// btnMarket
		const btnMarket = new BtnSceneLoadText(this, 1000, 400);
		this.add.existing(btnMarket);
		btnMarket.name = "btnMarket";
		btnMarket.removeInteractive();
		btnMarket.setInteractive(new Phaser.Geom.Rectangle(0, 0, 231, 67), Phaser.Geom.Rectangle.Contains);
		btnMarket.text = "Market";
		btnMarket.setStyle({ "fontSize": "64px" });

		// btnAddress
		const btnAddress = new BtnSceneLoadText(this, 17, 686);
		this.add.existing(btnAddress);
		btnAddress.name = "btnAddress";
		btnAddress.removeInteractive();
		btnAddress.setInteractive(new Phaser.Geom.Rectangle(0, 0, 1076, 33), Phaser.Geom.Rectangle.Contains);
		btnAddress.text = "Local Address: 0xFEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";
		btnAddress.setStyle({ "fontSize": "32px" });

		// ship2
		const ship2 = this.add.image(340, 434, "ship2");

		// glowFx
		ship2.preFX!.addGlow(6579218, 1, 0, false);

		// shineFx
		ship2.preFX!.addShine(0.05, 0.5, 3, false);

		// starfield (prefab fields)
		starfield.velocity = 0.02;

		// btnCrew (prefab fields)
		btnCrew.next = "Crew";

		// btnShips (prefab fields)
		btnShips.next = "Ships";

		// btnMission (prefab fields)
		btnMission.next = "Battle";

		// btnMarket (prefab fields)
		btnMarket.next = "Market";

		// btnAddress (prefab fields)
		btnAddress.next = "Wallet";

		this.starfield = starfield;
		this.btnCrew = btnCrew;
		this.btnShips = btnShips;
		this.btnMission = btnMission;
		this.lblWrilya = lblWrilya;
		this.btnMarket = btnMarket;
		this.btnAddress = btnAddress;

		this.events.emit("scene-awake");
	}

	private starfield!: Starfield;
	private btnCrew!: BtnSceneLoadText;
	private btnShips!: BtnSceneLoadText;
	private btnMission!: BtnSceneLoadText;
	private lblWrilya!: Phaser.GameObjects.Text;
	private btnMarket!: BtnSceneLoadText;
	private btnAddress!: BtnSceneLoadText;

	/* START-USER-CODE */

	create() {
		this.editorCreate();
		this.registerEvents();
		this.loadAddress();
	}

	// Write your code here
	private registerEvents() {
		//this.events.on('update', this.starfield.update, this.starfield);
		this.input.on('gameobjectdown', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.GameObject) => {
			if (obj instanceof BtnSceneLoadText) {
				obj.loadScene();
			}
		}, this);

		this.input.on('gameobjectover', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.Text) => {
			obj.setColor("#FFFF00");
		}, this);

		this.input.on('gameobjectout', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.Text) => {
			obj.setColor("#FFFFFF");
		}, this);

	}

	private loadAddress() {
		this.btnAddress.text = "Local Address: " + Game.Address();
	}


	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
