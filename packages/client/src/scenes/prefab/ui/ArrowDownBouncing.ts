
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class ArrowDownBouncing extends Phaser.GameObjects.Container {

	constructor(scene: Phaser.Scene, x?: number, y?: number) {
		super(scene, x ?? 1090, y ?? 365);

		// triangle
		const triangle = scene.add.triangle(-993, 130, 0, 128, 64, 0, 128, 128);
		triangle.angle = -180;
		triangle.isFilled = true;
		this.add(triangle);

		// rectangle
		const rectangle = scene.add.rectangle(-995, -80, 40, 300);
		rectangle.isFilled = true;
		this.add(rectangle);

		this.triangle = triangle;
		this.rectangle = rectangle;

		/* START-USER-CTR-CODE */
		scene.events.on('update', this.update, this);
		this.initArrowY = this.triangle.y;
		this.initRectangleY = this.rectangle.y;
		/* END-USER-CTR-CODE */
	}

	private triangle: Phaser.GameObjects.Triangle;
	private rectangle: Phaser.GameObjects.Rectangle;
	public velocity: number = 5;
	public distance: number = 100;

	/* START-USER-CODE */
	public direction: number = 1;
	public initArrowY: number = 0;
	public initRectangleY: number = 0;

	update(time: number, delta: number) {
		this.velocity = 5;
		this.distance = 100;

		const offset = this.direction * (delta / this.velocity);
		this.triangle.setY(this.triangle.y + offset);
		this.rectangle.setY(this.rectangle.y + offset);

		if (1 == this.direction && (this.distance <= (this.triangle.y - this.initArrowY))) {
			this.direction = -1;
		}
		else if (-1 == this.direction && this.initArrowY > this.triangle.y && (this.distance >= (this.initArrowY - this.triangle.y))) {
			this.direction = 1;
		}
	}
	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
