
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import Starfield from "../prefab/background/Starfield";
import BtnSceneLoadBack from "../prefab/ui/BtnSceneLoadBack";
import BtnStd from "../prefab/ui/BtnStd";
import LoadingFullScreen from "../prefab/ui/LoadingFullScreen";
/* START-USER-IMPORTS */
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin';
import { HomeEnum } from "../../mud";
import Game from "../../game";

/* END-USER-IMPORTS */

export default class Recruit extends Phaser.Scene {

	constructor() {
		super("Recruit");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// starfield
		const starfield = new Starfield(this, 0, 0);
		this.add.existing(starfield);

		// btnSceneLoadBack
		const btnSceneLoadBack = new BtnSceneLoadBack(this, 0, 615);
		this.add.existing(btnSceneLoadBack);

		// window
		const window = this.add.image(640, 360, "Window");
		window.scaleX = 0.9;
		window.scaleY = 0.9;

		// imgPortrait
		const imgPortrait = this.add.image(266, 165, "h_f_001");
		imgPortrait.name = "imgPortrait";
		imgPortrait.scaleX = 0.4;
		imgPortrait.scaleY = 0.4;
		imgPortrait.setOrigin(0, 0);

		// glowFx
		imgPortrait.preFX!.addGlow(16777215, 0, 4, false);

		// btnPortraitForwardA
		const btnPortraitForwardA = this.add.image(600, 620, "Forward_BTNA");
		btnPortraitForwardA.scaleX = 0.25;
		btnPortraitForwardA.scaleY = 0.25;

		// btnPortraitForward
		const btnPortraitForward = this.add.image(600, 620, "Forward_BTN");
		btnPortraitForward.scaleX = 0.25;
		btnPortraitForward.scaleY = 0.25;

		// hbPortraitForward
		const hbPortraitForward = this.add.rectangle(600, 620, 210, 210);
		hbPortraitForward.scaleX = 0.25;
		hbPortraitForward.scaleY = 0.25;

		// btnPortraitBackA
		const btnPortraitBackA = this.add.image(340, 620, "Backward_BTNA");
		btnPortraitBackA.scaleX = 0.25;
		btnPortraitBackA.scaleY = 0.25;

		// btnPortraitBack
		const btnPortraitBack = this.add.image(340, 620, "Backward_BTN");
		btnPortraitBack.scaleX = 0.25;
		btnPortraitBack.scaleY = 0.25;

		// hbPortraitBack
		const hbPortraitBack = this.add.rectangle(340, 620, 210, 210);
		hbPortraitBack.scaleX = 0.25;
		hbPortraitBack.scaleY = 0.25;

		// lblPortrait
		const lblPortrait = this.add.text(393, 602, "", {});
		lblPortrait.text = "Portrait";
		lblPortrait.setStyle({ "fontSize": "32px" });

		// ibName
		const ibName = this.add.rectangle(284, 30, 700, 90);
		ibName.setOrigin(0, 0);

		// bgBackStory
		const bgBackStory = this.add.image(714, 300, "Table_01");
		bgBackStory.scaleX = 0.75;
		bgBackStory.scaleY = 0.5;
		bgBackStory.setOrigin(0, 0);

		// ibHistory
		const ibHistory = this.add.rectangle(732, 311, 260, 220);
		ibHistory.setOrigin(0, 0);

		// lblHistory
		const lblHistory = this.add.text(720, 270, "", {});
		lblHistory.text = "History";
		lblHistory.setStyle({ "fontSize": "24px" });

		// lblHomeSystem
		const lblHomeSystem = this.add.text(710, 170, "", {});
		lblHomeSystem.text = "Home System";
		lblHomeSystem.setStyle({ "fontSize": "24px" });

		// btnRaceForwardA
		const btnRaceForwardA = this.add.image(995, 238, "Forward_BTNA");
		btnRaceForwardA.scaleX = 0.25;
		btnRaceForwardA.scaleY = 0.25;

		// btnRaceForward
		const btnRaceForward = this.add.image(995, 238, "Forward_BTN");
		btnRaceForward.scaleX = 0.25;
		btnRaceForward.scaleY = 0.25;

		// hbRaceForward
		const hbRaceForward = this.add.rectangle(995, 238, 210, 210);
		hbRaceForward.scaleX = 0.25;
		hbRaceForward.scaleY = 0.25;

		// btnRaceBackA
		const btnRaceBackA = this.add.image(735, 238, "Backward_BTNA");
		btnRaceBackA.scaleX = 0.25;
		btnRaceBackA.scaleY = 0.25;

		// btnRaceBack
		const btnRaceBack = this.add.image(735, 238, "Backward_BTN");
		btnRaceBack.scaleX = 0.25;
		btnRaceBack.scaleY = 0.25;

		// hbRaceBack
		const hbRaceBack = this.add.rectangle(735, 238, 210, 210);
		hbRaceBack.scaleX = 0.25;
		hbRaceBack.scaleY = 0.25;

		// lblRaceSelected
		const lblRaceSelected = this.add.text(862, 237, "", {});
		lblRaceSelected.setOrigin(0.5, 0.5);
		lblRaceSelected.text = "Human";
		lblRaceSelected.setStyle({ "align": "center", "fontSize": "32px" });

		// btnStd
		const btnStd = new BtnStd(this, 740, 560);
		this.add.existing(btnStd);
		btnStd.scaleX = 0.6;
		btnStd.scaleY = 0.5;

		// lblRecruit
		const lblRecruit = this.add.text(765, 575, "", {});
		lblRecruit.text = "Recruit";
		lblRecruit.setStyle({ "fontSize": "48px" });

		// uiLoading
		const uiLoading = new LoadingFullScreen(this, 0, 0);
		this.add.existing(uiLoading);
		uiLoading.visible = false;

		// starfield (prefab fields)
		starfield.velocity = 0.011414;

		// btnSceneLoadBack (prefab fields)
		btnSceneLoadBack.nextScene = "Crew";

		// uiLoading (prefab fields)
		uiLoading.velocity = 0.1;
		uiLoading.title = "Recruiting";
		uiLoading.message = "Recruiting Voidsman.  Please wait while your paperwork is processing...";

		this.btnSceneLoadBack = btnSceneLoadBack;
		this.imgPortrait = imgPortrait;
		this.btnPortraitForwardA = btnPortraitForwardA;
		this.btnPortraitForward = btnPortraitForward;
		this.hbPortraitForward = hbPortraitForward;
		this.btnPortraitBackA = btnPortraitBackA;
		this.btnPortraitBack = btnPortraitBack;
		this.hbPortraitBack = hbPortraitBack;
		this.ibName = ibName;
		this.ibHistory = ibHistory;
		this.btnRaceForwardA = btnRaceForwardA;
		this.btnRaceForward = btnRaceForward;
		this.hbRaceForward = hbRaceForward;
		this.btnRaceBackA = btnRaceBackA;
		this.btnRaceBack = btnRaceBack;
		this.hbRaceBack = hbRaceBack;
		this.lblRaceSelected = lblRaceSelected;
		this.btnStd = btnStd;
		this.lblRecruit = lblRecruit;
		this.uiLoading = uiLoading;

		this.events.emit("scene-awake");
	}

	private btnSceneLoadBack!: BtnSceneLoadBack;
	private imgPortrait!: Phaser.GameObjects.Image;
	private btnPortraitForwardA!: Phaser.GameObjects.Image;
	private btnPortraitForward!: Phaser.GameObjects.Image;
	private hbPortraitForward!: Phaser.GameObjects.Rectangle;
	private btnPortraitBackA!: Phaser.GameObjects.Image;
	private btnPortraitBack!: Phaser.GameObjects.Image;
	private hbPortraitBack!: Phaser.GameObjects.Rectangle;
	private ibName!: Phaser.GameObjects.Rectangle;
	private ibHistory!: Phaser.GameObjects.Rectangle;
	private btnRaceForwardA!: Phaser.GameObjects.Image;
	private btnRaceForward!: Phaser.GameObjects.Image;
	private hbRaceForward!: Phaser.GameObjects.Rectangle;
	private btnRaceBackA!: Phaser.GameObjects.Image;
	private btnRaceBack!: Phaser.GameObjects.Image;
	private hbRaceBack!: Phaser.GameObjects.Rectangle;
	private lblRaceSelected!: Phaser.GameObjects.Text;
	private btnStd!: BtnStd;
	private lblRecruit!: Phaser.GameObjects.Text;
	private uiLoading!: LoadingFullScreen;

	/* START-USER-CODE */

	private portraitsIndex: number = 0;
	private homeIndex: number = 0;

	// Write your code here

	create() {
		this.editorCreate();
		const rexButton: ButtonPlugin = this.scene.scene.plugins.get('rexButton') as ButtonPlugin;

		//-------------------------------------------------------------------------
		// Name Input Box
		//-------------------------------------------------------------------------
		const name = this.add.rexInputText(this.ibName.x, this.ibName.y, this.ibName.width, this.ibName.height, {
			type: 'text',
			placeholder: 'Enter name here!',
			align: 'center',
			fontSize: '64px',
		}).setOrigin(0, 0);

		//-------------------------------------------------------------------------
		// History Input Box
		//-------------------------------------------------------------------------
		const area = this.add.rexInputText(this.ibHistory.x, this.ibHistory.y, this.ibHistory.width, this.ibHistory.height, {
			type: 'textarea',
			placeholder: 'Enter Background Here!',
			align: 'left',
			fontSize: '16px',
		}).setOrigin(0, 0);

		//-------------------------------------------------------------------------
		// Recruit Button
		//-------------------------------------------------------------------------
		this.btnStd.onDown = () => { this.lblRecruit.setColor("#ffce4e"); };
		this.btnStd.onUp = () => { this.lblRecruit.setColor("#ffffff"); };
		this.btnStd.onOut = () => { this.lblRecruit.setColor("#ffffff"); };
		this.btnStd.onClick = async () => {
			area.setVisible(false);
			this.uiLoading.setVisible(true);
			const t: number = Date.now();
			console.log("[Recruit.Scene.btnStd.onClick] Recruiting Transaction Started");
			await Game.MUDSystemCalls().voidsmanCreate(name.text, Game.Portraits()[this.portraitsIndex], this.homeIndex as HomeEnum);
			console.log("[Recruit.Scene.btnStd.onClick] Recruiting Transaction Completed: %d (ms)", Date.now() - t);
			setTimeout(() => {
				this.uiLoading.setVisible(false);
				area.setVisible(true);
				this.scene.start(this.btnSceneLoadBack.nextScene);
			}, 2000);
		};
		//-------------------------------------------------------------------------
		// Race Buttons
		//-------------------------------------------------------------------------
		this.lblRaceSelected.text = HomeEnum[this.homeIndex];
		let racebutton = rexButton.add(this.hbRaceForward, {});
		racebutton.on('click', () => {
			this.homeIndex += 1;
			if (this.homeIndex >= HomeEnum.__LENGTH) {
				this.homeIndex = 1;
			}
			this.lblRaceSelected.text = HomeEnum[this.homeIndex];
		});
		racebutton.on('down', () => {
			this.btnRaceForward.visible = false;
		});
		racebutton.on('up', () => {
			this.btnRaceForward.visible = true;
		});
		racebutton.on('out', () => {
			this.btnRaceForward.visible = true;
		});

		racebutton = rexButton.add(this.hbRaceBack, {});
		racebutton.on('click', () => {
			this.homeIndex -= 1;
			if (this.homeIndex < 1) {
				this.homeIndex = HomeEnum.__LENGTH - 1;
			}
			this.lblRaceSelected.text = HomeEnum[this.homeIndex];
		});
		racebutton.on('down', () => {
			this.btnRaceBack.visible = false;
		});
		racebutton.on('up', () => {
			this.btnRaceBack.visible = true;
		});
		racebutton.on('out', () => {
			this.btnRaceBack.visible = true;
		});

		//-------------------------------------------------------------------------
		// Portrait Buttons Cycling
		//-------------------------------------------------------------------------
		this.portraitsIndex = Math.floor(Math.random() * Game.Portraits().length);
		this.imgPortrait.setTexture(Game.Portraits()[this.portraitsIndex]);

		let portraitbutton = rexButton.add(this.hbPortraitForward, {});
		portraitbutton.on('click', () => {
			const portraits: string[] = Game.Portraits();
			this.portraitsIndex += 1;
			if (this.portraitsIndex >= portraits.length) {
				this.portraitsIndex = 0;
			}
			this.imgPortrait.setTexture(portraits[this.portraitsIndex]);
		});
		portraitbutton.on('down', () => {
			this.btnPortraitForward.visible = false;
		});
		portraitbutton.on('up', () => {
			this.btnPortraitForward.visible = true;
		});
		portraitbutton.on('out', () => {
			this.btnPortraitForward.visible = true;
		});

		portraitbutton = rexButton.add(this.hbPortraitBack, {});
		portraitbutton.on('click', () => {
			const portraits: string[] = Game.Portraits();
			this.portraitsIndex -= 1;
			if (this.portraitsIndex < 0) {
				this.portraitsIndex = portraits.length - 1;
			}
			this.imgPortrait.setTexture(portraits[this.portraitsIndex]);
		});
		portraitbutton.on('down', () => {
			this.btnPortraitBack.visible = false;
		});
		portraitbutton.on('up', () => {
			this.btnPortraitBack.visible = true;
		});
		portraitbutton.on('out', () => {
			this.btnPortraitBack.visible = true;
		});
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
