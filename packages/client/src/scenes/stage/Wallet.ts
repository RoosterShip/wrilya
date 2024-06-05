
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import Starfield from "../prefab/background/Starfield";
import BtnSceneLoadBack from "../prefab/ui/BtnSceneLoadBack";
import BtnCopyText from "../prefab/ui/BtnCopyText";
/* START-USER-IMPORTS */
import Game from "../../game";
import ButtonPlugin from 'phaser3-rex-plugins/plugins/button-plugin';
/* END-USER-IMPORTS */

export default class Wallet extends Phaser.Scene {

	constructor() {
		super("Wallet");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// bgStarField
		const bgStarField = new Starfield(this, 0, 0);
		this.add.existing(bgStarField);

		// btnSceneLoadBack
		const btnSceneLoadBack = new BtnSceneLoadBack(this, 0, 615);
		this.add.existing(btnSceneLoadBack);

		// bgWindow
		const bgWindow = this.add.image(640, 360, "Window");
		bgWindow.scaleX = 0.9;
		bgWindow.scaleY = 0.9;

		// btnAddress
		const btnAddress = new BtnCopyText(this, 637, 77);
		this.add.existing(btnAddress);
		btnAddress.text.setOrigin(0.5, 0.5);
		btnAddress.text.text = "0xFEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE";
		btnAddress.text.setStyle({ "fontSize": "32px" });

		// lblTokenBalance
		const lblTokenBalance = this.add.text(272, 205, "", {});
		lblTokenBalance.text = "Token Balance";
		lblTokenBalance.setStyle({ "fontSize": "32px" });

		// lblTokenBalanceValue
		const lblTokenBalanceValue = this.add.text(615, 205, "", {});
		lblTokenBalanceValue.text = "0";
		lblTokenBalanceValue.setStyle({ "fontSize": "32px" });

		// lblStakeBalance
		const lblStakeBalance = this.add.text(273, 273, "", {});
		lblStakeBalance.text = "Staked Balance";
		lblStakeBalance.setStyle({ "fontSize": "32px" });

		// lblStakeBalanceValue
		const lblStakeBalanceValue = this.add.text(615, 275, "", {});
		lblStakeBalanceValue.text = "0";
		lblStakeBalanceValue.setStyle({ "fontSize": "32px" });

		// lblCreditBalance
		const lblCreditBalance = this.add.text(273, 343, "", {});
		lblCreditBalance.text = "Credit Balance";
		lblCreditBalance.setStyle({ "fontSize": "32px" });

		// lblCreditBalanceValue
		const lblCreditBalanceValue = this.add.text(615, 344, "", {});
		lblCreditBalanceValue.text = "0";
		lblCreditBalanceValue.setStyle({ "fontSize": "32px" });

		// lblDebitBalance
		const lblDebitBalance = this.add.text(272, 411, "", {});
		lblDebitBalance.text = "Debit Balance";
		lblDebitBalance.setStyle({ "fontSize": "32px" });

		// lblDebitBalanceValue
		const lblDebitBalanceValue = this.add.text(615, 415, "", {});
		lblDebitBalanceValue.text = "0";
		lblDebitBalanceValue.setStyle({ "fontSize": "32px" });

		// lblUnstakingBalance
		const lblUnstakingBalance = this.add.text(270, 479, "", {});
		lblUnstakingBalance.text = "Unstaking";
		lblUnstakingBalance.setStyle({ "fontSize": "32px" });

		// lblUnstakeBalanceValue
		const lblUnstakeBalanceValue = this.add.text(615, 475, "", {});
		lblUnstakeBalanceValue.text = "0";
		lblUnstakeBalanceValue.setStyle({ "fontSize": "32px" });

		// btnMint
		const btnMint = this.add.image(950, 228, "Table_02");
		btnMint.scaleX = 0.4;
		btnMint.scaleY = 0.4;

		// lblMint
		const lblMint = this.add.text(950, 225, "", {});
		lblMint.setOrigin(0.5, 0.5);
		lblMint.text = "Buy";
		lblMint.setStyle({ "fontSize": "32px" });

		// hbMint
		const hbMint = this.add.rectangle(950, 226, 350, 101);
		hbMint.scaleX = 0.4;
		hbMint.scaleY = 0.4;

		// btnStake
		const btnStake = this.add.image(950, 297, "Table_02");
		btnStake.scaleX = 0.4;
		btnStake.scaleY = 0.4;

		// lblStake
		const lblStake = this.add.text(950, 294, "", {});
		lblStake.setOrigin(0.5, 0.5);
		lblStake.text = "Stake";
		lblStake.setStyle({ "fontSize": "32px" });

		// hbStake
		const hbStake = this.add.rectangle(950, 296, 350, 101);
		hbStake.scaleX = 0.4;
		hbStake.scaleY = 0.4;

		// btnPay
		const btnPay = this.add.image(950, 434, "Table_02");
		btnPay.scaleX = 0.4;
		btnPay.scaleY = 0.4;

		// lblPay
		const lblPay = this.add.text(950, 431, "", {});
		lblPay.setOrigin(0.5, 0.5);
		lblPay.text = "Pay";
		lblPay.setStyle({ "fontSize": "32px" });

		// hbPay
		const hbPay = this.add.rectangle(950, 432, 350, 101);
		hbPay.scaleX = 0.4;
		hbPay.scaleY = 0.4;

		this.btnAddress = btnAddress;
		this.lblTokenBalanceValue = lblTokenBalanceValue;
		this.lblStakeBalanceValue = lblStakeBalanceValue;
		this.lblCreditBalanceValue = lblCreditBalanceValue;
		this.lblDebitBalanceValue = lblDebitBalanceValue;
		this.lblUnstakeBalanceValue = lblUnstakeBalanceValue;
		this.hbMint = hbMint;
		this.hbStake = hbStake;
		this.hbPay = hbPay;

		this.events.emit("scene-awake");
	}

	private btnAddress!: BtnCopyText;
	private lblTokenBalanceValue!: Phaser.GameObjects.Text;
	private lblStakeBalanceValue!: Phaser.GameObjects.Text;
	private lblCreditBalanceValue!: Phaser.GameObjects.Text;
	private lblDebitBalanceValue!: Phaser.GameObjects.Text;
	private lblUnstakeBalanceValue!: Phaser.GameObjects.Text;
	private hbMint!: Phaser.GameObjects.Rectangle;
	private hbStake!: Phaser.GameObjects.Rectangle;
	private hbPay!: Phaser.GameObjects.Rectangle;

	/* START-USER-CODE */

	// Write your code here

	create() {

		this.editorCreate();
		this.btnAddress.text.text = Game.Address();


		const rexButton: ButtonPlugin = this.scene.scene.plugins.get('rexButton') as ButtonPlugin;
		const buyButton = rexButton.add(this.hbMint, {});
		buyButton.on('click', async () => {
			await Game.MUDSystemCalls().currencyMint(100);
		});

		const stakeButton = rexButton.add(this.hbStake, {});
		stakeButton.on('click', async () => {
			await Game.MUDSystemCalls().currencyStake(10);
		});

		const payButton = rexButton.add(this.hbPay, {});
		payButton.on('click', async () => {
			await Game.MUDSystemCalls().currencyPayment(10);
		});
	}

	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	update(time: number, delta: number) {
		this.lblCreditBalanceValue.text = Game.Credits().toString();
		this.lblDebitBalanceValue.text = Game.Debit().toString() + " / " + Game.MaxDebit().toString();
		this.lblStakeBalanceValue.text = Game.Stake().toString();
		this.lblTokenBalanceValue.text = Game.Tokens().toString();
		this.lblUnstakeBalanceValue.text = Game.Unstake().toString();
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
