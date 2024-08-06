
// You can write more code here

/* START OF COMPILED CODE */

import UIButtonStandard from "./UIButtonStandard";
/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

export default class UIButtonShipsIcon extends UIButtonStandard {

  constructor(scene: Phaser.Scene, x?: number, y?: number) {
    super(scene, x ?? 0, y ?? 0);

    // ship_h
    const ship_h = scene.add.image(0, 0, "inventory_h");
    ship_h.setOrigin(0, 0);
    this.add(ship_h);

    // ship_n
    const ship_n = scene.add.image(0, 0, "inventory_n");
    ship_n.setOrigin(0, 0);
    this.add(ship_n);

    // ship_p
    const ship_p = scene.add.image(0, 0, "inventory_p");
    ship_p.setOrigin(0, 0);
    this.add(ship_p);

    // ship_d
    const ship_d = scene.add.image(0, 0, "inventory_p");
    ship_d.setOrigin(0, 0);
    this.add(ship_d);

    // hitbox
    const hitbox = scene.add.rectangle(0, 0, 25, 25);
    hitbox.setOrigin(0, 0);
    this.add(hitbox);

    /* START-USER-CTR-CODE */

    this.setup(
      hitbox,
      ship_n,
      ship_p,
      ship_h,
      ship_d
    )
    this.onClick = () => {
      scene.scene.start("Ship");
    }
    // Write your code here.
    /* END-USER-CTR-CODE */
  }

  /* START-USER-CODE */

  // Write your code here.

  /* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
