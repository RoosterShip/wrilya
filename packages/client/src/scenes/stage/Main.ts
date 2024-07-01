
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import Starfield from "../prefab/background/Starfield";
import BtnSceneLoadText from "../prefab/ui/BtnSceneLoadText";
import Support from "../prefab/ui/window/Support";
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

		// lblTokens
		const lblTokens = this.add.text(17, 566, "", {});
		lblTokens.text = "Tokens: ";
		lblTokens.setStyle({ "color": "#41ff4dff", "fontSize": "32px" });

		// lblCredits
		const lblCredits = this.add.text(17, 606, "", {});
		lblCredits.text = "Credits: ";
		lblCredits.setStyle({ "color": "#9d99feff", "fontSize": "32px" });

		// lblDebit
		const lblDebit = this.add.text(17, 646, "", {});
		lblDebit.text = "Debit: ";
		lblDebit.setStyle({ "color": "#fd6666ff", "fontSize": "32px" });

		// lblTokensAmt
		const lblTokensAmt = this.add.text(200, 566, "", {});
		lblTokensAmt.text = "0";
		lblTokensAmt.setStyle({ "color": "#41ff4dff", "fontSize": "32px" });

		// lblCreditsAmt
		const lblCreditsAmt = this.add.text(200, 606, "", {});
		lblCreditsAmt.text = "0";
		lblCreditsAmt.setStyle({ "color": "#9d99feff", "fontSize": "32px" });

		// lblDebitAmt
		const lblDebitAmt = this.add.text(200, 646, "", {});
		lblDebitAmt.text = "0";
		lblDebitAmt.setStyle({ "color": "#fd6666ff", "fontSize": "32px" });

		// btnWallet
		const btnWallet = new BtnSceneLoadText(this, 1000, 500);
		this.add.existing(btnWallet);
		btnWallet.name = "btnWallet";
		btnWallet.removeInteractive();
		btnWallet.setInteractive(new Phaser.Geom.Rectangle(0, 0, 231, 67), Phaser.Geom.Rectangle.Contains);
		btnWallet.text = "Wallet";
		btnWallet.setStyle({ "fontSize": "64px" });

		// support
		const support = new Support(this, 213, 30);
		this.add.existing(support);

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

		// btnWallet (prefab fields)
		btnWallet.next = "Wallet";

		this.starfield = starfield;
		this.btnCrew = btnCrew;
		this.btnShips = btnShips;
		this.btnMission = btnMission;
		this.lblWrilya = lblWrilya;
		this.btnMarket = btnMarket;
		this.btnAddress = btnAddress;
		this.lblTokensAmt = lblTokensAmt;
		this.lblCreditsAmt = lblCreditsAmt;
		this.lblDebitAmt = lblDebitAmt;
		this.btnWallet = btnWallet;

		this.events.emit("scene-awake");
	}

	private starfield!: Starfield;
	private btnCrew!: BtnSceneLoadText;
	private btnShips!: BtnSceneLoadText;
	private btnMission!: BtnSceneLoadText;
	private lblWrilya!: Phaser.GameObjects.Text;
	private btnMarket!: BtnSceneLoadText;
	private btnAddress!: BtnSceneLoadText;
	private lblTokensAmt!: Phaser.GameObjects.Text;
	private lblCreditsAmt!: Phaser.GameObjects.Text;
	private lblDebitAmt!: Phaser.GameObjects.Text;
	private btnWallet!: BtnSceneLoadText;

	/* START-USER-CODE */


	// Code to load the Support Prefab
	//	const support = new Support(this, 213, 30);
	//	this.add.existing(support);

	create() {
		this.editorCreate();
		this.registerEvents();
		this.loadAddress();
	}

	// Update Callback
	//
	// Lint checks disabled because Phaser requires the arguments
	// 
	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	update(_time: number, _delta: number) {
		this.lblTokensAmt.text = Game.Tokens().toString();
		this.lblCreditsAmt.text = Game.Credits().toString();
		this.lblDebitAmt.text = Game.Debit().toString();
	}

	private registerEvents() {
		this.input.on('gameobjectdown', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.GameObject) => {
			if (obj instanceof BtnSceneLoadText) {
				obj.loadScene();
			}
		}, this);

		this.input.on('gameobjectover', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.Text) => {
			if (obj instanceof BtnSceneLoadText) {
				obj.setColor("#FFFF00");
			}
		}, this);

		this.input.on('gameobjectout', (pointer: Phaser.Input.Pointer, obj: Phaser.GameObjects.Text) => {
			if (obj instanceof BtnSceneLoadText) {
				obj.setColor("#FFFFFF");
			}
		}, this);

	}

	private loadAddress() {
		this.btnAddress.text = "Local Address: " + Game.Address();
	}


	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
