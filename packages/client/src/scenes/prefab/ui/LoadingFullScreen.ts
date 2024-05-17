
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class LoadingFullScreen extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 0, y ?? 0);

		// hbBackDrop
		const hbBackDrop = scene.add.rectangle(0, 0, 1280, 720);
		hbBackDrop.setInteractive(new Phaser.Geom.Rectangle(0, 0, 1280, 720), Phaser.Geom.Rectangle.Contains);
		hbBackDrop.setOrigin(0, 0);
		hbBackDrop.isFilled = true;
		hbBackDrop.fillAlpha = 0.1;
		this.add(hbBackDrop);

		// imgWindow
		const imgWindow = scene.add.image(640, 360, "Table_01");
		imgWindow.scaleY = 0.5;
		this.add(imgWindow);

		// imgSpinner
		const imgSpinner = scene.add.image(640, 440, "Dot_02");
		imgSpinner.scaleX = 0.5;
		imgSpinner.scaleY = 0.5;
		this.add(imgSpinner);

		// lblTitle
		const lblTitle = scene.add.text(640, 260, "", {});
		lblTitle.setOrigin(0.5, 0.5);
		lblTitle.text = "Loading";
		lblTitle.setStyle({ "align": "center", "fontSize": "32px" });
		lblTitle.setWordWrapWidth(lblTitle.style.wordWrapWidth!, true);
		this.add(lblTitle);

		// lblMessage
		const lblMessage = scene.add.text(640, 319, "", {});
		lblMessage.setOrigin(0.5, 0);
		lblMessage.text = "This is some loading text";
		lblMessage.setStyle({ "align": "center", "baselineY": 1.55, "fixedWidth": 340, "fixedHeight": 90, "fontSize": "24px" });
		lblMessage.setWordWrapWidth(340);
		this.add(lblMessage);

		this.imgSpinner = imgSpinner;
		this.lblTitle = lblTitle;
		this.lblMessage = lblMessage;

		/* START-USER-CTR-CODE */
		scene.events.on('update', this.update, this);
		/* END-USER-CTR-CODE */
	}

	private imgSpinner: Phaser.GameObjects.Image;
	public lblTitle: Phaser.GameObjects.Text;
	public lblMessage: Phaser.GameObjects.Text;
	public velocity: number = 1;
	public showScale: number = 0;
	public title: string = "Loading";
	public message: string = "Loading";

	/* START-USER-CODE */
	show() {
		this.scale = this.showScale;
		this.setVisible(true);
	}

	display() {
		this.scale = 1;
		this.setVisible(true);
	}

	hide() {
		this.setVisible(false);
	}

	update(time: number, delta: number) {
		// NOTE:  Would be better to 
		this.lblTitle.text = this.title;
		this.lblMessage.text = this.message;

		this.imgSpinner.setAngle(this.imgSpinner.angle + (this.velocity * delta));
		if (this.scale < 1) {
			this.scale += delta;
		}
		if (this.scale > 1) {
			this.scale = 1;
		}
	}

	// Write your code here.

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
