
// You can write more code here

/* START OF COMPILED CODE */

import Phaser from "phaser";
import BarArmor from "../prefab/ui/BarArmor";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class Battle extends Phaser.Scene {

	constructor() {
		super("Battle");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// ship_001
		const ship_001 = this.add.tilemap("ship_001");
		ship_001.addTilesetImage("ship_tiles", "ship_tiles");

		// bg_004
		const bg_004 = this.add.image(0, 0, "bg_004");
		bg_004.scaleX = 0.5;
		bg_004.scaleY = 0.5;
		bg_004.setOrigin(0, 0);

		// barArmor
		const barArmor = new BarArmor(this, 0, 0);
		this.add.existing(barArmor);

		// ship
		const ship = this.add.container(0, 0);

		// floors
		const floors = ship_001.createLayer("Floor", ["ship_tiles"], 100, 0)!;
		floors.scaleX = 0.5;
		floors.scaleY = 0.5;
		ship.add(floors);

		// walls
		const walls = ship_001.createLayer("Walls", ["ship_tiles"], 100, 0)!;
		walls.scaleX = 0.5;
		walls.scaleY = 0.5;
		ship.add(walls);

		// objects
		const objects = ship_001.createLayer("Objects", ["ship_tiles"], 100, 0)!;
		objects.scaleX = 0.5;
		objects.scaleY = 0.5;
		ship.add(objects);

		// doors
		const doors = ship_001.createLayer("Doors", ["ship_tiles"], 100, 0)!;
		doors.scaleX = 0.5;
		doors.scaleY = 0.5;
		ship.add(doors);

		// doorsA
		const doorsA = ship_001.createLayer("Door_Activators", ["ship_tiles"], 100, 0)!;
		doorsA.scaleX = 0.5;
		doorsA.scaleY = 0.5;
		ship.add(doorsA);

		// markers
		const markers = ship_001.createLayer("Use_Markers", ["ship_tiles"], 100, 0)!;
		markers.scaleX = 0.5;
		markers.scaleY = 0.5;
		ship.add(markers);

		// blocked
		const blocked = ship_001.createLayer("Blocked", ["ship_tiles"], 100, 0)!;
		blocked.scaleX = 0.5;
		blocked.scaleY = 0.5;
		blocked.visible = false;
		ship.add(blocked);

		// table
		const table = this.add.image(892, 97, "Table");
		table.setOrigin(0, 0);

		// wship1
		this.add.image(1086, 393, "wship1");

		// table_02
		const table_02 = this.add.image(1084, 148, "Table_02");
		table_02.scaleX = 1.12;

		// lblEnemyName
		const lblEnemyName = this.add.text(1086, 142, "", {});
		lblEnemyName.setOrigin(0.5, 0.5);
		lblEnemyName.text = "Enemy Name";
		lblEnemyName.setStyle({ "align": "center", "fontSize": "48px" });

		this.floors = floors;
		this.walls = walls;
		this.doorsA = doorsA;
		this.lblEnemyName = lblEnemyName;
		this.ship_001 = ship_001;

		this.events.emit("scene-awake");
	}

	private floors!: Phaser.Tilemaps.TilemapLayer;
	private walls!: Phaser.Tilemaps.TilemapLayer;
	private doorsA!: Phaser.Tilemaps.TilemapLayer;
	private lblEnemyName!: Phaser.GameObjects.Text;
	private ship_001!: Phaser.Tilemaps.Tilemap;

	/* START-USER-CODE */

	// Write your code here

	create() {

		this.editorCreate();
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
