// Copyright (C) 2024 Decentralized Consulting
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

// You can write more code here

//-----------------------------------------------------------------------------
// Phaser Editor Generated Code
//-----------------------------------------------------------------------------

/* START OF COMPILED CODE */

import Phaser from "phaser";
import Starfield from "../prefab/background/Starfield";
import BtnSceneLoad from "../prefab/ui/BtnSceneLoad";
import BtnStd from "../prefab/ui/BtnStd";
import BtnLast from "../prefab/ui/BtnLast";
import BtnNext from "../prefab/ui/BtnNext";
import ArrowDownBouncing from "../prefab/ui/ArrowDownBouncing";
import BtnUpgrade from "../prefab/ui/BtnUpgrade";
import LoadingFullScreen from "../prefab/ui/LoadingFullScreen";
/* START-USER-IMPORTS */
import { Voidsman } from '../../actors'
import Game from '../../game';
import { Home, Field } from "../../mud";
/* END-USER-IMPORTS */

export default class Crew extends Phaser.Scene {

	constructor() {
		super("Crew");

		/* START-USER-CTR-CODE */
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// starfield
		const starfield = new Starfield(this, 0, 0);
		this.add.existing(starfield);

		// window
		const window = this.add.image(640, 360, "Window");
		window.scaleX = 0.9;
		window.scaleY = 0.9;

		// btnRecruit
		const btnRecruit = new BtnSceneLoad(this, 740, 560);
		this.add.existing(btnRecruit);
		btnRecruit.scaleX = 0.6;
		btnRecruit.scaleY = 0.5;

		// lblRecruit
		const lblRecruit = this.add.text(765, 575, "", {});
		lblRecruit.text = "Recruit";
		lblRecruit.setStyle({ "fontSize": "48px" });

		// imgPortrait
		const imgPortrait = this.add.image(266, 165, "h_m_002");
		imgPortrait.scaleX = 0.4;
		imgPortrait.scaleY = 0.4;
		imgPortrait.setOrigin(0, 0);

		// glowFx
		imgPortrait.preFX!.addGlow(16777215, 0, 4, false);

		// pixelateFx
		const pixelateFx = imgPortrait.preFX!.addPixelate(20);

		// lblName
		const lblName = this.add.text(641, 77, "", {});
		lblName.setOrigin(0.5, 0.5);
		lblName.text = "Select Voidsman";
		lblName.setStyle({ "align": "center", "fontSize": "64px" });

		// lblTrainingTime
		const lblTrainingTime = this.add.text(470, 599, "", {});
		lblTrainingTime.setOrigin(0.5, 0.5);
		lblTrainingTime.text = "Training Remaining";
		lblTrainingTime.setStyle({ "fontSize": "32px" });

		// btnCertify
		const btnCertify = new BtnStd(this, 385, 625);
		this.add.existing(btnCertify);
		btnCertify.scaleX = 0.4;
		btnCertify.scaleY = 0.3;

		// lblTrainingTimeValue
		const lblTrainingTimeValue = this.add.text(470, 650, "", {});
		lblTrainingTimeValue.setOrigin(0.5, 0.5);
		lblTrainingTimeValue.text = "Certify";
		lblTrainingTimeValue.setStyle({ "fontSize": "32px" });

		// btnLast
		const btnLast = new BtnLast(this, 270, 50);
		this.add.existing(btnLast);
		btnLast.scaleX = 0.25;
		btnLast.scaleY = 0.25;

		// btnNext
		const btnNext = new BtnNext(this, 960, 50);
		this.add.existing(btnNext);
		btnNext.scaleX = 0.25;
		btnNext.scaleY = 0.25;

		// btnBack
		const btnBack = new BtnLast(this, 0, 615);
		this.add.existing(btnBack);
		btnBack.scaleX = 0.5;
		btnBack.scaleY = 0.5;

		// lblArmor
		const lblArmor = this.add.text(753, 200, "", {});
		lblArmor.text = "Armor";
		lblArmor.setStyle({ "fontSize": "24px" });

		// lblEngines
		const lblEngines = this.add.text(753, 240, "", {});
		lblEngines.text = "Engines";
		lblEngines.setStyle({ "fontSize": "24px" });

		// lblLeadership
		const lblLeadership = this.add.text(753, 280, "", {});
		lblLeadership.text = "Leadership";
		lblLeadership.setStyle({ "fontSize": "24px" });

		// lblNavigation
		const lblNavigation = this.add.text(753, 320, "", {});
		lblNavigation.text = "Navigation";
		lblNavigation.setStyle({ "fontSize": "24px" });

		// lblNegotiation
		const lblNegotiation = this.add.text(753, 360, "", {});
		lblNegotiation.text = "Negotiation\n";
		lblNegotiation.setStyle({ "fontSize": "24px" });

		// lblShipcraft
		const lblShipcraft = this.add.text(753, 400, "", {});
		lblShipcraft.text = "Shipcraft\n";
		lblShipcraft.setStyle({ "fontSize": "24px" });

		// lblSensors
		const lblSensors = this.add.text(753, 440, "", {});
		lblSensors.text = "Sensors\n";
		lblSensors.setStyle({ "fontSize": "24px" });

		// lblShields
		const lblShields = this.add.text(753, 480, "", {});
		lblShields.text = "Shields\n";
		lblShields.setStyle({ "fontSize": "24px" });

		// lblWeapons
		const lblWeapons = this.add.text(753, 520, "", {});
		lblWeapons.text = "Weapons\n";
		lblWeapons.setStyle({ "fontSize": "24px" });

		// lblArmorValue
		const lblArmorValue = this.add.text(973, 200, "", {});
		lblArmorValue.setOrigin(1, 0);
		lblArmorValue.text = "0";
		lblArmorValue.setStyle({ "fontSize": "24px" });

		// lblEnginesValue
		const lblEnginesValue = this.add.text(973, 240, "", {});
		lblEnginesValue.setOrigin(1, 0);
		lblEnginesValue.text = "1";
		lblEnginesValue.setStyle({ "fontSize": "24px" });

		// lblLeadershipValue
		const lblLeadershipValue = this.add.text(973, 280, "", {});
		lblLeadershipValue.setOrigin(1, 0);
		lblLeadershipValue.text = "2";
		lblLeadershipValue.setStyle({ "fontSize": "24px" });

		// lblNavigationValue
		const lblNavigationValue = this.add.text(973, 320, "", {});
		lblNavigationValue.setOrigin(1, 0);
		lblNavigationValue.text = "3";
		lblNavigationValue.setStyle({ "fontSize": "24px" });

		// lblNegotiationValue
		const lblNegotiationValue = this.add.text(973, 360, "", {});
		lblNegotiationValue.setOrigin(1, 0);
		lblNegotiationValue.text = "4";
		lblNegotiationValue.setStyle({ "fontSize": "24px" });

		// lblShipcraftValue
		const lblShipcraftValue = this.add.text(973, 401, "", {});
		lblShipcraftValue.setOrigin(1, 0);
		lblShipcraftValue.text = "5";
		lblShipcraftValue.setStyle({ "fontSize": "24px" });

		// lblSensorsValue
		const lblSensorsValue = this.add.text(973, 441, "", {});
		lblSensorsValue.setOrigin(1, 0);
		lblSensorsValue.text = "6";
		lblSensorsValue.setStyle({ "fontSize": "24px" });

		// lblShieldsValue
		const lblShieldsValue = this.add.text(973, 481, "", {});
		lblShieldsValue.setOrigin(1, 0);
		lblShieldsValue.text = "7";
		lblShieldsValue.setStyle({ "fontSize": "24px" });

		// lblWeaponsValue
		const lblWeaponsValue = this.add.text(973, 520, "", {});
		lblWeaponsValue.setOrigin(1, 0);
		lblWeaponsValue.text = "8";
		lblWeaponsValue.setStyle({ "fontSize": "24px" });

		// lblHome
		const lblHome = this.add.text(753, 160, "", {});
		lblHome.text = "Home";
		lblHome.setStyle({ "fontSize": "24px" });

		// lblHomeValue
		const lblHomeValue = this.add.text(973, 160, "", {});
		lblHomeValue.setOrigin(1, 0);
		lblHomeValue.text = "HOME WORLD";
		lblHomeValue.setStyle({ "fontSize": "24px" });

		// lblArrowDownBouncing
		const lblArrowDownBouncing = new ArrowDownBouncing(this, 1356, 385);
		this.add.existing(lblArrowDownBouncing);
		lblArrowDownBouncing.scaleX = 0.5;
		lblArrowDownBouncing.scaleY = 0.5;

		// btnUpgradeArmor
		const btnUpgradeArmor = new BtnUpgrade(this, 994, 200);
		this.add.existing(btnUpgradeArmor);
		btnUpgradeArmor.scaleX = 0.12;
		btnUpgradeArmor.scaleY = 0.12;

		// btnUpgradeEngines
		const btnUpgradeEngines = new BtnUpgrade(this, 994, 240);
		this.add.existing(btnUpgradeEngines);
		btnUpgradeEngines.scaleX = 0.12;
		btnUpgradeEngines.scaleY = 0.12;

		// btnUpgradeLeadership
		const btnUpgradeLeadership = new BtnUpgrade(this, 994, 280);
		this.add.existing(btnUpgradeLeadership);
		btnUpgradeLeadership.scaleX = 0.12;
		btnUpgradeLeadership.scaleY = 0.12;

		// btnUpgradeNavigation
		const btnUpgradeNavigation = new BtnUpgrade(this, 994, 320);
		this.add.existing(btnUpgradeNavigation);
		btnUpgradeNavigation.scaleX = 0.12;
		btnUpgradeNavigation.scaleY = 0.12;

		// btnUpgradeNegotiation
		const btnUpgradeNegotiation = new BtnUpgrade(this, 993, 360);
		this.add.existing(btnUpgradeNegotiation);
		btnUpgradeNegotiation.scaleX = 0.12;
		btnUpgradeNegotiation.scaleY = 0.12;

		// btnUpgradeShipcraft
		const btnUpgradeShipcraft = new BtnUpgrade(this, 993, 400);
		this.add.existing(btnUpgradeShipcraft);
		btnUpgradeShipcraft.scaleX = 0.12;
		btnUpgradeShipcraft.scaleY = 0.12;

		// btnUpgradeSensors
		const btnUpgradeSensors = new BtnUpgrade(this, 993, 440);
		this.add.existing(btnUpgradeSensors);
		btnUpgradeSensors.scaleX = 0.12;
		btnUpgradeSensors.scaleY = 0.12;

		// btnUpgradeShields
		const btnUpgradeShields = new BtnUpgrade(this, 993, 480);
		this.add.existing(btnUpgradeShields);
		btnUpgradeShields.scaleX = 0.12;
		btnUpgradeShields.scaleY = 0.12;

		// btnUpgradeWeapons
		const btnUpgradeWeapons = new BtnUpgrade(this, 993, 520);
		this.add.existing(btnUpgradeWeapons);
		btnUpgradeWeapons.scaleX = 0.12;
		btnUpgradeWeapons.scaleY = 0.12;

		// uiLoading
		const uiLoading = new LoadingFullScreen(this, 0, -1);
		this.add.existing(uiLoading);
		uiLoading.visible = false;

		// starfield (prefab fields)
		starfield.velocity = 0.01;

		// btnRecruit (prefab fields)
		btnRecruit.nextScene = "Recruit";

		// lblArrowDownBouncing (prefab fields)
		lblArrowDownBouncing.velocity = 3;

		// uiLoading (prefab fields)
		uiLoading.velocity = 0.2;
		uiLoading.showScale = 0;

		this.btnRecruit = btnRecruit;
		this.lblRecruit = lblRecruit;
		this.pixelateFx = pixelateFx;
		this.imgPortrait = imgPortrait;
		this.lblName = lblName;
		this.lblTrainingTime = lblTrainingTime;
		this.btnCertify = btnCertify;
		this.lblTrainingTimeValue = lblTrainingTimeValue;
		this.btnLast = btnLast;
		this.btnNext = btnNext;
		this.btnBack = btnBack;
		this.lblArmor = lblArmor;
		this.lblEngines = lblEngines;
		this.lblLeadership = lblLeadership;
		this.lblNavigation = lblNavigation;
		this.lblNegotiation = lblNegotiation;
		this.lblShipcraft = lblShipcraft;
		this.lblSensors = lblSensors;
		this.lblShields = lblShields;
		this.lblWeapons = lblWeapons;
		this.lblArmorValue = lblArmorValue;
		this.lblEnginesValue = lblEnginesValue;
		this.lblLeadershipValue = lblLeadershipValue;
		this.lblNavigationValue = lblNavigationValue;
		this.lblNegotiationValue = lblNegotiationValue;
		this.lblShipcraftValue = lblShipcraftValue;
		this.lblSensorsValue = lblSensorsValue;
		this.lblShieldsValue = lblShieldsValue;
		this.lblWeaponsValue = lblWeaponsValue;
		this.lblHome = lblHome;
		this.lblHomeValue = lblHomeValue;
		this.lblArrowDownBouncing = lblArrowDownBouncing;
		this.btnUpgradeArmor = btnUpgradeArmor;
		this.btnUpgradeEngines = btnUpgradeEngines;
		this.btnUpgradeLeadership = btnUpgradeLeadership;
		this.btnUpgradeNavigation = btnUpgradeNavigation;
		this.btnUpgradeNegotiation = btnUpgradeNegotiation;
		this.btnUpgradeShipcraft = btnUpgradeShipcraft;
		this.btnUpgradeSensors = btnUpgradeSensors;
		this.btnUpgradeShields = btnUpgradeShields;
		this.btnUpgradeWeapons = btnUpgradeWeapons;
		this.uiLoading = uiLoading;

		this.events.emit("scene-awake");
	}

	private btnRecruit!: BtnSceneLoad;
	private lblRecruit!: Phaser.GameObjects.Text;
	private pixelateFx!: Phaser.FX.Pixelate;
	private imgPortrait!: Phaser.GameObjects.Image;
	private lblName!: Phaser.GameObjects.Text;
	private lblTrainingTime!: Phaser.GameObjects.Text;
	private btnCertify!: BtnStd;
	private lblTrainingTimeValue!: Phaser.GameObjects.Text;
	private btnLast!: BtnLast;
	private btnNext!: BtnNext;
	private btnBack!: BtnLast;
	private lblArmor!: Phaser.GameObjects.Text;
	private lblEngines!: Phaser.GameObjects.Text;
	private lblLeadership!: Phaser.GameObjects.Text;
	private lblNavigation!: Phaser.GameObjects.Text;
	private lblNegotiation!: Phaser.GameObjects.Text;
	private lblShipcraft!: Phaser.GameObjects.Text;
	private lblSensors!: Phaser.GameObjects.Text;
	private lblShields!: Phaser.GameObjects.Text;
	private lblWeapons!: Phaser.GameObjects.Text;
	private lblArmorValue!: Phaser.GameObjects.Text;
	private lblEnginesValue!: Phaser.GameObjects.Text;
	private lblLeadershipValue!: Phaser.GameObjects.Text;
	private lblNavigationValue!: Phaser.GameObjects.Text;
	private lblNegotiationValue!: Phaser.GameObjects.Text;
	private lblShipcraftValue!: Phaser.GameObjects.Text;
	private lblSensorsValue!: Phaser.GameObjects.Text;
	private lblShieldsValue!: Phaser.GameObjects.Text;
	private lblWeaponsValue!: Phaser.GameObjects.Text;
	private lblHome!: Phaser.GameObjects.Text;
	private lblHomeValue!: Phaser.GameObjects.Text;
	private lblArrowDownBouncing!: ArrowDownBouncing;
	private btnUpgradeArmor!: BtnUpgrade;
	private btnUpgradeEngines!: BtnUpgrade;
	private btnUpgradeLeadership!: BtnUpgrade;
	private btnUpgradeNavigation!: BtnUpgrade;
	private btnUpgradeNegotiation!: BtnUpgrade;
	private btnUpgradeShipcraft!: BtnUpgrade;
	private btnUpgradeSensors!: BtnUpgrade;
	private btnUpgradeShields!: BtnUpgrade;
	private btnUpgradeWeapons!: BtnUpgrade;
	private uiLoading!: LoadingFullScreen;

	/* START-USER-CODE */

	//-----------------------------------------------------------------------------
	// Implementation Created Code
	//-----------------------------------------------------------------------------

	private voidsmanIndex = 0;

	// Write your code here
	create() {
		// Initialize UI Based on settings from Phaser Editor
		this.editorCreate();

		// Setup UI Button Handlers
		this.setupButtonHandlers()
	}

	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	update(time: number, delta: number) {
		const crew = Game.Crew();

		// State:  NO CREW
		if (crew.size == 0) {
			this.displayStateEmpty();
		}
		else {
			const key: string = Array.from(crew.keys())[this.voidsmanIndex];
			this.displayStateVoidsman(crew.get(key)!)
		}
	}

	//-----------------------------------------------------------------------------
	// Private Helpers
	//-----------------------------------------------------------------------------

	/**
	 * Action handler for when the "Training" button has been selected
	 * @param field to train the voidsman in
	 */
	private async trainVoidsman(field: Field) {
		// Get the voidsman to train	
		const crew = Game.Crew();
		const key: string = Array.from(crew.keys())[this.voidsmanIndex];
		const voidsman = crew.get(key)!;

		// set the popup message and show it
		this.uiLoading.title = "Begin Training"
		this.uiLoading.message = "Ordering your books now!"
		this.uiLoading.show();

		// Issue the blockchain request
		const t: number = Date.now();
		console.log("[Crew.trainVoidsman] Certify Voidsman Started");
		await voidsman.beginTraining(field);
		console.log("[Crew.trainVoidsman] Certify Voidsman Complete %d (ms)", Date.now() - t);

		// Shutdown Popup
		setTimeout(() => {
			this.uiLoading.setVisible(false);
		}, 2000);
	}

	/**
	 * Action handler for when the certify button is clicked
	 */
	private async certifyVoidsman() {
		// Get the voidsman to certify
		const crew = Game.Crew();
		const key: string = Array.from(crew.keys())[this.voidsmanIndex];
		const voidsman = crew.get(key)!;

		// Set the popup message and show it
		this.uiLoading.title = "Certify Training"
		this.uiLoading.message = voidsman.name() + " is taking their test now!";
		this.uiLoading.show();

		// Issue the blockchain request
		const t: number = Date.now();
		console.log("[Crew.certifyVoidsman] Certify Voidsman Started");
		await voidsman.certifyTraining();
		console.log("[Crew.certifyVoidsman] Certify Voidsman Complete %d (ms)", Date.now() - t);

		// Shutdown Popup
		setTimeout(() => {
			this.uiLoading.setVisible(false);
		}, 2000);
	}

	private setupButtonHandlers() {
		// Back Button
		this.btnBack.onClick = () => { this.scene.start("Main"); }

		// Recruit Button
		this.btnRecruit.onDown = () => { this.lblRecruit.setColor("orange"); }
		this.btnRecruit.onOut = () => { this.lblRecruit.setColor("white"); }
		this.btnRecruit.onUp = () => { this.lblRecruit.setColor("white"); }

		// Certify Button
		this.btnCertify.onClick = () => { this.certifyVoidsman(); }
		this.btnCertify.onDown = () => { this.lblTrainingTimeValue.setColor("orange"); }
		this.btnCertify.onOut = () => { this.lblTrainingTimeValue.setColor("white"); }
		this.btnCertify.onUp = () => { this.lblTrainingTimeValue.setColor("white"); }

		// All the upgrade Buttons
		this.btnUpgradeArmor.onClick = async () => { this.trainVoidsman(Field.ARMOR); };
		this.btnUpgradeEngines.onClick = async () => { this.trainVoidsman(Field.ENGINES); };
		this.btnUpgradeLeadership.onClick = async () => { this.trainVoidsman(Field.LEADERSHIP); };
		this.btnUpgradeNavigation.onClick = async () => { this.trainVoidsman(Field.NAVIGATION); };
		this.btnUpgradeNegotiation.onClick = async () => { this.trainVoidsman(Field.NEGOTIATION); };
		this.btnUpgradeShipcraft.onClick = async () => { this.trainVoidsman(Field.SHIPCRAFT); };
		this.btnUpgradeSensors.onClick = async () => { this.trainVoidsman(Field.SENSORS); };
		this.btnUpgradeShields.onClick = async () => { this.trainVoidsman(Field.SHIELDS); };
		this.btnUpgradeWeapons.onClick = async () => { this.trainVoidsman(Field.WEAPONS); };

		// Crew member selection buttons
		this.btnNext.onClick = () => {
			this.voidsmanIndex += 1;
			if (this.voidsmanIndex >= Game.Crew().size) {
				this.voidsmanIndex = 0;
			}
		}
		this.btnLast.onClick = () => {
			this.voidsmanIndex -= 1;
			if (this.voidsmanIndex < 0) {
				this.voidsmanIndex = Game.Crew().size - 1;
			}
		}
	}

	private displayStateEmpty() {
		// There are no crewmen so let's shut it all down
		this.btnLast.setVisible(false);
		this.btnNext.setVisible(false);
		this.lblName.setText("No Crew");
		this.lblHome.setVisible(false);
		this.lblHomeValue.setVisible(false);
		this.lblArmor.setVisible(false);
		this.lblArmorValue.setVisible(false);
		this.lblEngines.setVisible(false);
		this.lblEnginesValue.setVisible(false);
		this.lblLeadership.setVisible(false);
		this.lblLeadershipValue.setVisible(false);
		this.lblNavigation.setVisible(false);
		this.lblNavigationValue.setVisible(false);
		this.lblNegotiation.setVisible(false);
		this.lblNegotiationValue.setVisible(false);
		this.lblShipcraft.setVisible(false);
		this.lblShipcraftValue.setVisible(false);
		this.lblSensors.setVisible(false);
		this.lblSensorsValue.setVisible(false);
		this.lblShields.setVisible(false);
		this.lblShieldsValue.setVisible(false);
		this.lblWeapons.setVisible(false);
		this.lblWeaponsValue.setVisible(false);
		this.btnCertify.setVisible(false);
		this.lblTrainingTime.setVisible(false);
		this.lblTrainingTimeValue.setVisible(false);
		// Upgrade Buttons
		this.upgradeButtonsSetVisible(false);
	}

	private upgradeButtonsSetVisible(visible: boolean) {
		this.btnUpgradeArmor.setVisible(visible);
		this.btnUpgradeEngines.setVisible(visible);
		this.btnUpgradeLeadership.setVisible(visible);
		this.btnUpgradeNavigation.setVisible(visible);
		this.btnUpgradeNegotiation.setVisible(visible);
		this.btnUpgradeShipcraft.setVisible(visible);
		this.btnUpgradeSensors.setVisible(visible);
		this.btnUpgradeShields.setVisible(visible);
		this.btnUpgradeWeapons.setVisible(visible);
	}

	private displayStateCrew(crew: Map<string, Voidsman>) {
		// In the case of only one voidsman turn off the buttons
		this.lblArrowDownBouncing.setActive(false);
		this.lblArrowDownBouncing.setVisible(false);
		this.pixelateFx.amount = -1;

		// Select a random Crewman
		this.voidsmanIndex = Math.floor(Math.random() * crew.size);
	}

	private displayStateVoidsman(voidsman: Voidsman) {
		// Turn off unneeded UI
		this.pixelateFx.setActive(false);
		this.lblArrowDownBouncing.setVisible(false);

		this.loadVoidsman(voidsman);
		if (voidsman?.isTraining()) {
			if (voidsman.isCertifiable()) {
				this.displayStateVoidsmanCertify();
			}
			else {
				this.displayStateVoidsmanTraining(voidsman);
			}
		}
		else {
			this.displayStateVoidsmanReady();
		}
	}

	private displayStateVoidsmanCertify() {
		this.upgradeButtonsSetVisible(false);
		this.lblTrainingTime.setVisible(true);
		this.lblTrainingTimeValue.setVisible(true);
		this.lblTrainingTime.setText("Training Complete");
		this.lblTrainingTimeValue.setText("Certify");
		this.btnCertify.setVisible(true);
	}

	private displayStateVoidsmanTraining(voidsman: Voidsman) {
		this.upgradeButtonsSetVisible(false);
		this.lblTrainingTime.setVisible(true);
		this.lblTrainingTimeValue.setVisible(true);
		this.lblTrainingTime.setText("Training finished in:");
		this.lblTrainingTimeValue.setText(this.secondsToDhms(voidsman.trainingComplete()));
		this.btnCertify.setVisible(false);
	}

	private displayStateVoidsmanReady() {
		this.upgradeButtonsSetVisible(true);
		this.btnCertify.setVisible(false);
		this.lblTrainingTime.setVisible(false);
		this.lblTrainingTimeValue.setText("Select topic to study");
	}

	private loadVoidsman(voidsman: Voidsman) {
		// Load up the voidsman
		this.imgPortrait.setTexture(voidsman!.portrait());
		this.lblName.setText(voidsman!.name());
		this.lblHomeValue.setText(Home[voidsman!.home()]);
		this.lblArmorValue.setText(voidsman!.competencies()[Field.ARMOR].toString(10));
		this.lblEnginesValue.setText(voidsman!.competencies()[Field.ENGINES].toString(10));
		this.lblLeadershipValue.setText(voidsman!.competencies()[Field.LEADERSHIP].toString(10));
		this.lblNavigationValue.setText(voidsman!.competencies()[Field.NAVIGATION].toString(10));
		this.lblNegotiationValue.setText(voidsman!.competencies()[Field.NEGOTIATION].toString(10));
		this.lblShipcraftValue.setText(voidsman!.competencies()[Field.SHIPCRAFT].toString(10));
		this.lblSensorsValue.setText(voidsman!.competencies()[Field.SENSORS].toString(10));
		this.lblShieldsValue.setText(voidsman!.competencies()[Field.SHIELDS].toString(10));
		this.lblWeaponsValue.setText(voidsman!.competencies()[Field.WEAPONS].toString(10));
	}

	private secondsToDhms(time: number) {

		const seconds = time - (Date.now() / 1000);

		const d = Math.floor(seconds / (3600 * 24));
		const h = Math.floor(seconds % (3600 * 24) / 3600);
		const m = Math.floor(seconds % 3600 / 60);
		const s = Math.floor(seconds % 60);

		const dDisplay = d > 9 ? d.toString() : "0" + d.toString();
		const hDisplay = h > 9 ? h.toString() : "0" + h.toString();
		const mDisplay = m > 9 ? m.toString() : "0" + m.toString();
		const sDisplay = s > 9 ? s.toString() : "0" + s.toString();
		return dDisplay + " : " + hDisplay + " : " + mDisplay + " : " + sDisplay;
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here